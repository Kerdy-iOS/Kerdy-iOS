//
//  LoginService.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/26/23.
//

import Moya


struct AuthRequestDTO: Codable {
    let token: String
    let memberId: Int
}

enum LoginAPI {
    case signIn(code: String)
    case fcm(request: AuthRequestDTO)
}

extension LoginAPI: KerdyAPI {
    
    var domain: KerdyDomain {
        return .auth
    }
    
    var urlPath: String {
        switch self {
        case .signIn:
            return "/login/github/callback"
        case .fcm:
            return "/notifications/token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .fcm:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .signIn(code):
            return .requestParameters(parameters: [ "code": code ],
                                      encoding: URLEncoding.default)
        case let .fcm(request: request):
            return .requestJSONEncodable(request)
        }
    }
        
    var headerType: HTTPHeaderFields {
        switch self {
        case .signIn:
            return .html
        case .fcm:
            return .plain
        }
    }
    
    var error: [Int: NetworkError]? {
        switch self {
        case .signIn, .fcm:
            return nil
        }
    }
}
