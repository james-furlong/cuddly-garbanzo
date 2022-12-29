//
//  HTTPHeaders.swift
//  Dexcom Monitor
//
//  Created by James on 29/12/2022.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPHeader: String {
    case accept = "Accept"
    case authorization = "Authorization"
    case clientContext = "x-archa-client-context"
    case contentType = "Content-Type"
    case contentLength = "Content-Length"
    case created = "(created)"
    case digest = "Digest"
    case host = "Host"
    case requestTarget = "(request-target)"
    case signature = "Signature"
    case link = "Link"
    case location = "Location"
    case idempotency = "Idempotency-Token"
    case authProcessToken = "Archa-Auth-Process-Token"
}
