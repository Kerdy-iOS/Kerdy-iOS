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
    
    var parameters: [String: Any]? {
        switch self {
        case .getUserFeed:
            return nil
        case .getFeeds(eventID: let id):
            return ["event-id": id]
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getUserFeed, .getFeeds:
            return ["Authorization": "Bearer " + (KeyChainManager.read(forkey: .accessToken) ?? "")]
        }
    }
    
    var error: [Int: NetworkError]? {
        switch self {
        case .getUserFeed, .getFeeds:
            return nil
        }
    }
}
