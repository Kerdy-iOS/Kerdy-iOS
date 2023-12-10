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
}

extension FeedAPI: KerdyAPI {
    
    var domain: KerdyDomain {
        return .feed
    }
    
    var urlPath: String {
        switch self {
        case .getUserFeed:
            return "/my"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserFeed:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getUserFeed:
            return nil
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getUserFeed:
            return ["Authorization": "Bearer " + (KeyChainManager.read(forkey: .accessToken) ?? "")]
        }
    }
    
    var error: [Int: NetworkError]? {
        switch self {
        case .getUserFeed:
            return nil
        }
    }
}
