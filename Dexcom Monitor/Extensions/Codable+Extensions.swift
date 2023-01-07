//
//  Codable+Extensions.swift
//  Dexcom Monitor
//
//  Created by James on 30/12/2022.
//

import Foundation

protocol UrlEncodable {
    var bodyComponents: URLComponents { get }
}

extension Encodable {
    func encodedToString() -> String? {
        guard let data: Data = self.encodedToData() else { return nil }
        guard let stringValue: String = String(data: data, encoding: .utf8) else { return nil }
        
        return stringValue
    }
    
    func encodedToData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
