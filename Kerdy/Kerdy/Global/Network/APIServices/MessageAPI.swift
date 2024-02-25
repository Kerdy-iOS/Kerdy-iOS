//
//  MessageAPI.swift
//  Kerdy
//
//  Created by 이동현 on 2/25/24.
//

import Foundation
import Moya

enum MessageAPI {
    case postMessge(senderId: Int, receiverId: Int, content: String)
}

extension MessageAPI: KerdyAPI {
    var domain: KerdyDomain {
        return .messages
    }
    
    var urlPath: String {
        switch self {
        case .postMessge:
            return ""
        }
    }
    
    var error: [Int : NetworkError]? {
        switch self {
        case .postMessge:
            return nil
        }
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .postMessge:
            return .plain
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postMessge:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postMessge(
            senderId: let senderId,
            receiverId: let receiverId,
            content: let content
        ):
            let parameters: [String: Any] = [
                "senderId" : senderId,
                "receiverId" : receiverId,
                "content" : content
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
