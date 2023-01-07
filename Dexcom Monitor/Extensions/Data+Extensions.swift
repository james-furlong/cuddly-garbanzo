//
//  Data+Extensions.swift
//  Dexcom Monitor
//
//  Created by James on 30/12/2022.
//

import Foundation

extension Data {
    func decoded<T: Decodable>(to type: T.Type) -> T? {
        return decodedResult(to: type).successOrNull()
    }
    
    func decodedResult<T: Decodable>(to type: T.Type) -> Result<T, Error> {
        let result: Result<T, Error> = Result {
            try JSONDecoder().decode(type, from: self)
        }

        switch result {
            case .success(let data):
                return Result.success(data)

            case .failure(let error):
                switch error {
                    case DecodingError.keyNotFound(let codingKey, let context):
                        let keyPath: String = context.codingPath
                            .appending(codingKey)
                            .enumerated()
                            .map { index, codingKey -> String in
                                if let intValue: Int = codingKey.intValue { return "[\(intValue)]" }
                                
                                return "\(index == 0 ? "" : ".")\(codingKey.stringValue)"
                            }
                            .joined()
                        let errorString = "Expected to decode '\(String(describing: type))' but could not parse key '\(keyPath)'"
                        Injector.log.error("Parsing Error: \(errorString)")
                        
                    case DecodingError.typeMismatch(let type, _):
                        // See the explanation in 'encodedToData' to explain this but
                        // since data from these methods can be cached to disk we can't
                        // limit the "unwrapping" to specific versions as the user could
                        // cache something on an affected version, update their OS and
                        // then attempt to uncache on an unaffected version
                        switch decodedResult(to: Array<T>.self) {
                            case .success(let arrayResult):
                                guard let value: T = arrayResult.first else {
                                    return Result.failure(
                                        NetworkError.parsing(
                                            description: "Unable to unwrap array-wrapped primitive of \(type)"
                                        )
                                    )
                                }
                                
                                return Result.success(value)
                                
                            case .failure(let error): return Result.failure(error)
                        }
                    
                    default:
                        Injector.log.error("Parsing Error: Expected to decode '\(String(describing: type))' but received error - \(error)")
                }
                
                return Result.failure(NetworkError.parsing(description: error.localizedDescription))
        }
    }
    
    func formattedString() -> String {
        let targetData: Data

        if let jsonObject: Any = try? JSONSerialization.jsonObject(with: self, options: []), let jsonData: Data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) {
            targetData = jsonData
        }
        else {
            targetData = self
        }

        if let bodyString: String = String(data: targetData, encoding: .utf8), !bodyString.isEmpty {
            return bodyString
        }

        return ""
    }
    
    func decoded<O>(as type: O.Type) -> Result<O, Error> where O: Decodable {
        // Emit straight away if we are decdoing as 'Data'
        if type == Data.self, let finalData = self as? O {
            return .success(finalData)
        }
        
        return self.decodedResult(to: type)
    }
}
