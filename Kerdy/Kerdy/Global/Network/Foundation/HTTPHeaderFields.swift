//
//  HTTPHeaderFields.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/10/23.
//

import Foundation

enum HTTPHeaderFieldsKey {
    static let contentType = "Content-Type"
    static let authorization = "Authorization"
}

enum HTTPHeaderFieldsValue {
    static let html = "application/x-www-form-urlencoded"
    static let json = "application/json"
    static var accessToken: String { KeyChainManager.loadAccessToken() }
}

enum HTTPHeaderFields {
    case plain
    case html
    case hasAccessToken
}
