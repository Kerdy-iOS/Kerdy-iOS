//
//  ImageAPI.swift
//  Kerdy
//
//  Created by 이동현 on 12/24/23.
//

import Foundation
import Moya

enum ImageAPI {
    case getImage(url: String)
    case getProfileImage(url: String)
}

extension ImageAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .getImage:
            return URL(string: BaseInfoManager.imageBaseURL)!
        case .getProfileImage(url: let url):
            return URL(string: url)!
        }
        
    }
    
    var path: String {
        switch self {
        case .getImage(let url):
            return "\(url)"
        case .getProfileImage:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getImage:
            return .get
        case .getProfileImage:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getImage:
            return .requestPlain
        case .getProfileImage:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getImage:
            return [:]
        case .getProfileImage:
            return [:]
        }
    }
}
