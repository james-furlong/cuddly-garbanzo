//
//  CacheClient.swift
//  Dexcom Monitor
//
//  Created by James on 1/1/2023.
//

import Foundation

protocol CacheClientType {
    func cache(_ value: Any?, forKey key: Storable)
    func cacheWithResult(_ value: Any?, forKey key: Storable) -> Bool
    func data(forKey key: Storable) -> Data?
    func string(forKey key: Storable) -> String?
    func int(forKey key: Storable) -> Int?
    func bool(forKey key: Storable) -> Bool
    func boolOrNull(forKey key: Storable) -> Bool?
    func object<T: Codable>(ofType: T.Type, forKey key: Storable) -> T?
    
    func remove(key: Storable)
    func contains(key: Storable) -> Bool
}

class CacheClient: CacheClientType {
    private var userDefaults: UserDefaults = UserDefaults.standard
    private var keychain: KeychainWrapperType = KeychainWrapper()
    
    // Internal functions
    
    private func storeData(_ data: Data, forKey key: Storable) -> Bool {
        // If it shouldn't survive app deletion then store in user defaults
        if !key.isSensitive {
            userDefaults.set(data.base64EncodedString(), forKey: key.rawValue)
            return true
        }
        
        // Otherwise try to store in keychain
        guard let keychainKey: Constants.KeychainDataKey = key as? Constants.KeychainDataKey else { return false }
        keychain[keychainKey] = data.base64EncodedString()
        return true
    }
    
    private func retrieveData(forKey key: Storable) -> Data? {
        let maybeDataString: String?

        if !key.isSensitive {
            maybeDataString = userDefaults.string(forKey: key.rawValue)
        }
        else {
            guard let keychainKey: Constants.KeychainDataKey = key as? Constants.KeychainDataKey else { return nil }
            maybeDataString = keychain[keychainKey]
        }
        
        guard let dataString: String = maybeDataString else { return nil }
  
        return Data(base64Encoded: dataString)
    }
    
    // Exposed functions
    
    func cache(_ value: Any?, forKey key: Storable) {
        _ = cacheWithResult(value, forKey: key)
    }
    
    func cacheWithResult(_ value: Any?, forKey key: Storable) -> Bool {
        let maybeValueData: Data?

        // Convert the value to Data
        switch value {
            case let valueString as String: maybeValueData = valueString.data(using: .utf8)
            case let valueInt as Int: maybeValueData = "\(valueInt)".data(using: .utf8)
            case let valueBool as Bool: maybeValueData = "\(valueBool)".data(using: .utf8)
            case let directValueData as Data: maybeValueData = directValueData
            case let valueCodable as Codable:
                maybeValueData = valueCodable.encodedToString()?.data(using: .utf8)
            default: maybeValueData = nil
        }
        
        guard let valueData: Data = maybeValueData else {
            Injector.log.error("Unable to cache unknown value type for key \(key.rawValue)")
            return false
        }
        
        // Store the data
        return storeData(valueData, forKey: key)
    }

    func data(forKey key: Storable) -> Data? {
        return retrieveData(forKey: key)
    }

    func string(forKey key: Storable) -> String? {
        guard let data: Data = data(forKey: key) else { return nil }

        return String(data: data, encoding: .utf8)
    }
    
    func int(forKey key: Storable) -> Int? {
        guard let string: String = string(forKey: key) else { return nil }
        
        return Int(string)
    }

    func bool(forKey key: Storable) -> Bool {
        return (boolOrNull(forKey: key) == true)
    }
    
    func boolOrNull(forKey key: Storable) -> Bool? {
        guard let string: String = string(forKey: key) else { return nil }

        return (string == "true")
    }
    
    func object<T: Codable>(ofType type: T.Type, forKey key: Storable) -> T? {
        guard let data: Data = data(forKey: key) else { return nil }
        
        return data.decoded(to: type)
    }
    
    func remove(key: Storable) {
        if !key.isSensitive {
            // If it shouldn't survive app deletion, remove from user defaults
            userDefaults.removeObject(forKey: key.rawValue)
        }
        else if let keychainKey: Constants.KeychainDataKey = key as? Constants.KeychainDataKey {
            // Remove from keychain
            keychain[keychainKey] = nil
        }
    }
    
    func contains(key: Storable) -> Bool {
        if !key.isSensitive {
            return (userDefaults.value(forKey: key.rawValue) != nil)
        }
        
        if let keychainKey: Constants.KeychainDataKey = key as? Constants.KeychainDataKey {
            return (keychain[keychainKey] != nil)
        }
        
        return false
    }
}
