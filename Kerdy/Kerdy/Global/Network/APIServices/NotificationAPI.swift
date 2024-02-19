//
//  NotificationAPI.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/8/23.
//

import Foundation

import Moya

enum NotificationAPI {
    case notificationList(id: Int)
    case readState(id: Int)
    case deleteNotification(ids: [Int])
}

extension NotificationAPI: KerdyAPI {
    
    var domain: KerdyDomain {
        return .notification
    }
    
    var urlPath: String {
        switch self {
        case .notificationList, .deleteNotification:
            return ""
        case .readState(id: let id):
            return "/\(id)/read"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .notificationList:
            return .get
        case .readState:
            return .patch
        case .deleteNotification:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .notificationList(id: let id):
            let parameters: [String: Any] = ["member-id": id]
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.default)
        case .deleteNotification(ids: let ids):
            let parameters: [String: [Int]] = ["deleteIds": ids]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .readState:
            return .requestPlain
        }
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .notificationList, .readState, .deleteNotification:
            return .hasAccessToken
        }
    }
    
    var error: [Int: NetworkError]? {
        switch self {
        case .notificationList, .readState, .deleteNotification:
            return nil
        }
    }
}
