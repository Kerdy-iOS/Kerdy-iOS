//
//  LoginService.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/26/23.
//

import Moya

enum LoginAPI {
    case signIn(code: String)
}

extension LoginAPI: KerdyAPI {
    
    var domain: KerdyDomain {
        return .login
    }
    
    var urlPath: String {
        switch self {
        case .signIn:
            return "/github/callback"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .signIn(code):
            return [ "code": code ]
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .signIn:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
    
    var error: [Int: NetworkError]? {
        switch self {
        case .signIn:
            return nil
        }
    }
}
