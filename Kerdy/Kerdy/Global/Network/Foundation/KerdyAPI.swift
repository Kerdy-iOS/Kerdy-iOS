//
//  KerdyAPI.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/26/23.
//

import Foundation

import Moya

/// Kerdy 도메인
enum KerdyDomain {
    case activity
    case member
    case event
    case comment
    case auth
    case block
    case tag
    case report
    case scrap
    case messages
    case feed
    case notification
    case rooms
}

extension KerdyDomain {
    /// 도메인에 따른 기본 url - Kerdy API Docs
    var url: String {
        switch self {
        case .activity:
            return "/activities"
        case .member:
            return "/members"
        case .event:
            return "/events"
        case .comment:
            return "/comments"
        case .block:
            return "/blocks"
        case .tag, .auth:
            return ""
        case .report:
            return "/reports"
        case .scrap:
            return "/scraps"
        case .messages:
            return "/messages"
        case .feed:
            return "/feeds"
        case .notification:
            return "/notifications"
        case .rooms:
            return "/rooms"
        }
    }
}

/// Kerdy API가 기본적으로 준수해야 하는 정보
///
/// domain : Kerdy Domain(ex. activity, member, login ...)
/// urlPath : Domain 뒤에 붙는 상세 경로(path)
/// error : 상태코드에 따른 NetworkError 구분하는데 사용되는 딕셔너리
protocol KerdyAPI: TargetType {
    var domain: KerdyDomain { get }
    var urlPath: String { get }
    var error: [Int: NetworkError]? { get }
    var headerType: HTTPHeaderFields { get }
}

extension KerdyAPI {
    var baseURL: URL {
        return URL(string: BaseInfoManager.baseURL)!
    }
    
    var path: String {
        return domain.url + urlPath
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var headers: [String: String]? {
        switch headerType {
        case .plain:
            return [
                HTTPHeaderFieldsKey.contentType: HTTPHeaderFieldsValue.json
            ]
        case .html:
            return [
                HTTPHeaderFieldsKey.contentType: HTTPHeaderFieldsValue.html
            ]
        case .hasAccessToken:
            return [
                HTTPHeaderFieldsKey.contentType: HTTPHeaderFieldsValue.json,
                HTTPHeaderFieldsKey.authorization: HTTPHeaderFieldsValue.accessToken
            ]
        }
    }
}
