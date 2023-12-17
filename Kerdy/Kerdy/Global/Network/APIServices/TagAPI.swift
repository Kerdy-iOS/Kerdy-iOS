//
//  TagAPI.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/8/23.
//

import Foundation

import Moya

enum TagAPI {
    case allTags
    case updateTags(id: [Int])
    case getTags(memberID: Int)
    case deleteTags(id: [Int])
}

extension TagAPI: KerdyAPI {
    
    var domain: KerdyDomain {
        return .tag
    }
    
    var urlPath: String {
        switch self {
        case .allTags:
            return "/tags"
        case .updateTags, .deleteTags:
            return "/interest-tags"
        case .getTags:
            return "/interest-tags"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .allTags:
            return .get
        case .updateTags:
            return .put
        case .getTags:
            return .get
        case .deleteTags:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .allTags:
            return .requestPlain
        case .updateTags(id: let id), .deleteTags(id: let id):
            let parameters: [String: Any] = ["tagIds": id]
            return .requestParameters(parameters: parameters, 
                                      encoding: JSONEncoding.default)
        case .getTags(memberID: let id):
            let parameters: [String: Any] = ["member_id": id]
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.default)
        }
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .allTags, .getTags:
            return .plain
        case .updateTags, .deleteTags:
            return .hasAccessToken
        }
    }
    
    var error: [Int: NetworkError]? {
        switch self {
        case .allTags, .updateTags, .getTags, .deleteTags:
            return nil
        }
    }
}
