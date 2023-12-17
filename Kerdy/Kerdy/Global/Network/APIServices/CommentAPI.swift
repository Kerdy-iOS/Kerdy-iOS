//
//  CommentAPI.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import Foundation

import Moya

enum CommentAPI {
    case getAllComments(memberID: Int)
}

extension CommentAPI: KerdyAPI {
    
    var domain: KerdyDomain {
        return .comment
    }
    
    var urlPath: String {
        switch self {
        case .getAllComments:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllComments:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getAllComments(memberID: let memberID):
            let parameter = ["memberId": memberID ]
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        }
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getAllComments:
            return .hasAccessToken
        }
    }

    var error: [Int: NetworkError]? {
        switch self {
        case .getAllComments:
            return nil
        }
    }
}
