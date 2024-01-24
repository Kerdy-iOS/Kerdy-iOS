//
//  ScrapAPI.swift
//  Kerdy
//
//  Created by 이동현 on 12/24/23.
//

import Foundation
import Moya

enum ScrapAPI {
    case getScraps
    case addScrap(id: Int)
    case deleteScrap(id: Int)
}

extension ScrapAPI: KerdyAPI {
    
    var domain: KerdyDomain {
        return .scrap
    }
    
    var urlPath: String {
        switch self {
        case .getScraps, .addScrap, .deleteScrap:
            return ""
        }
    }
    
    var error: [Int: NetworkError]? {
        switch self {
        case .getScraps, .addScrap, .deleteScrap:
            return nil
        }
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getScraps, .addScrap, .deleteScrap:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getScraps:
            return .get
        case .addScrap:
            return .post
        case .deleteScrap:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getScraps:
            return .requestPlain
        case .addScrap(let id):
            return .requestParameters(parameters: ["eventId": id], encoding: JSONEncoding.default)
        case .deleteScrap(let id):
            return .requestParameters(parameters: ["event-id": id], encoding: JSONEncoding.default)
        }
    }
}
