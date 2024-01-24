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
}

extension ImageAPI: TargetType {
    var baseURL: URL {
        return URL(string: BaseInfoManager.imageBaseURL)!
    }
    
    var path: String {
        switch self {
        case .getImage(let url):
            return "\(url)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getImage:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getImage:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getImage:
            return [:]
        }
    }
}
