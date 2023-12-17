//
//  CommentAPI.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import Foundation

import Moya

enum CommentAPI {
    case getUserComments(memberID: Int)
    case getDetailComments(commentID: Int)
}

extension CommentAPI: KerdyAPI {
    
    var domain: KerdyDomain {
        return .comment
    }
    
    var urlPath: String {
        switch self {
        case .getUserComments:
            return ""
        case .getDetailComments(commentID: let commentID):
            return "/\(commentID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserComments, .getDetailComments:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUserComments(memberID: let memberID):
            let parameter = ["memberId": memberID ]
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        case .getDetailComments:
            return .requestPlain
        }
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getUserComments, .getDetailComments:
            return .hasAccessToken
        }
    }

    var error: [Int: NetworkError]? {
        switch self {
        case .getUserComments, .getDetailComments:
            return nil
        }
    }
}
