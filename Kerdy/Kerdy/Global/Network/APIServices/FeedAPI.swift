//
//  FeedAPI.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import Foundation

import Moya

enum FeedAPI {
    case getUserFeed
    case getFeeds(eventID: Int)
}

extension FeedAPI: KerdyAPI {

    var domain: KerdyDomain {
        return .feed
    }
    
    var urlPath: String {
        switch self {
        case .getUserFeed:
            return "/my"
        case .getFeeds:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserFeed, .getFeeds:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getUserFeed:
            return .requestPlain
        case .getFeeds(eventID: let id):
             return .requestParameters(parameters: ["event-id": id],
                                          encoding: URLEncoding.default)
        }
    }

    var headerType: HTTPHeaderFields {
        switch self {
        case .getUserFeed, .getFeeds:
            return .hasAccessToken
        }
    }

    var error: [Int: NetworkError]? {
        switch self {
        case .getUserFeed, .getFeeds:
            return nil
        }
    }
}
