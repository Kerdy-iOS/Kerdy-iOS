//
//  CommentAPI.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import Foundation

import Moya

struct CommentsRequestDTO: Codable {
    let content: String
    let feedId: Int
    let parentId: Int?
}

enum CommentAPI {
    case getUserComments(memberID: Int)
    case getDetailComments(commentID: Int)
    case postComments(request: CommentsRequestDTO)
}

extension CommentAPI: KerdyAPI {
    
    var domain: KerdyDomain {
        return .comment
    }
    
    var urlPath: String {
        switch self {
        case .getUserComments, .postComments:
            return ""
        case .getDetailComments(commentID: let commentID):
            return "/\(commentID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserComments, .getDetailComments:
            return .get
        case .postComments:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getUserComments(memberID: let memberID):
            let parameter = ["memberId": memberID ]
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        case .getDetailComments:
            return .requestPlain
        case .postComments(request: let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getUserComments, .getDetailComments, .postComments:
            return .hasAccessToken
        }
    }

    var error: [Int: NetworkError]? {
        switch self {
        case .getUserComments, .getDetailComments, .postComments:
            return nil
        }
    }
}
