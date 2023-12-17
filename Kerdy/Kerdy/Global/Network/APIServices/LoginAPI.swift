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
    
    var task: Task {
        switch self {
        case let .signIn(code):
            return .requestParameters(parameters: [ "code": code ],
                                      encoding: URLEncoding.default)
        }
    }
        
    var headerType: HTTPHeaderFields {
        switch self {
        case .signIn:
            return .html
        }
    }
    
    var error: [Int: NetworkError]? {
        switch self {
        case .signIn:
            return nil
        }
    }
}
