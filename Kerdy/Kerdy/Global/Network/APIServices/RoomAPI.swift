//
//  RoomAPI.swift
//  Kerdy
//
//  Created by 이동현 on 2/25/24.
//

import Foundation
import Moya

enum RoomAPI {
    case getRooms(memberId: Int)
    case getRoomByUUID(uuid: String)
    case getRoomByUserId(receiverId: Int)
}

extension RoomAPI: KerdyAPI {
    var domain: KerdyDomain {
        return .rooms
    }
    
    var urlPath: String {
        switch self {
        case .getRooms:
            return "/overview"
        case .getRoomByUUID(uuid: let uuid):
            return "/\(uuid)"
        case .getRoomByUserId:
            return ""
        }
    }
    
    var error: [Int : NetworkError]? {
        return nil
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getRooms:
            return .hasAccessToken
        case .getRoomByUUID:
            return .hasAccessToken
        case .getRoomByUserId:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRooms:
            return .get
        case .getRoomByUUID:
            return .get
        case .getRoomByUserId:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getRooms(memberId: let memberId):
            let parameter: [String: Any] = ["member-id": memberId]
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        case .getRoomByUUID:
            return .requestPlain
        case .getRoomByUserId(receiverId: let receiverId):
            let parameter: [String: Any] = ["receiver-id": receiverId]
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        }
    }
}
