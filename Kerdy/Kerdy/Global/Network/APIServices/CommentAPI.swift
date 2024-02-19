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
    var feedId: Int?
    var parentId: Int?
}

enum CommentAPI {
    case getUserComments(memberID: Int)
    case getDetailComments(commentID: Int)
    case postComments(request: CommentsRequestDTO)
    case deleteComment(commentID: Int)
    case patchcomments(commentID: Int, content: String)
}

extension CommentAPI: KerdyAPI {
    
    var domain: KerdyDomain {
        return .comment
    }
    
    var urlPath: String {
        switch self {
        case .getUserComments, .postComments:
            return ""
        case .getDetailComments(commentID: let commentID), .deleteComment(commentID: let commentID), .patchcomments(commentID: let commentID, _):
            return "/\(commentID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserComments, .getDetailComments:
            return .get
        case .postComments:
            return .post
        case .deleteComment:
            return .delete
        case .patchcomments:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .getUserComments(memberID: let memberID):
            let parameter = ["memberId": memberID ]
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        case .getDetailComments, .deleteComment:
            return .requestPlain
        case .postComments(request: let data):
            return .requestJSONEncodable(data)
        case .patchcomments(_, content: let data):
            let parameter = ["content": data]
            return .requestParameters(parameters: parameter, encoding: JSONEncoding.default)
        }
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getUserComments, .getDetailComments, .postComments, .deleteComment, .patchcomments:
            return .hasAccessToken
        }
    }

    var error: [Int: NetworkError]? {
        switch self {
        case .getUserComments, .getDetailComments, .postComments, .deleteComment, .patchcomments:
            return nil
        }
    }
}
