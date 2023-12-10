//
//  SettingAPI.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/1/23.
//

import Foundation

import Moya

enum SettingAPI {
    case profile(id: Int)
}

extension SettingAPI: KerdyAPI {

    var domain: KerdyDomain {
        return .member
    }
    
    var urlPath: String {
        switch self {
        case .profile(id: let id):
            return "/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .profile:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .profile:
            return .none
        }
    }

    var error: [Int: NetworkError]? {
        switch self {
        case .profile:
            return nil
        }
    }
}
