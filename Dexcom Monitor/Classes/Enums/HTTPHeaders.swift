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
    case contentType = "Content-Type"
    case contentLength = "Content-Length"
    case host = "Host"
    case requestTarget = "(request-target)"
    case link = "Link"
    case location = "Location"
    case idempotency = "Idempotency-Token"
}
