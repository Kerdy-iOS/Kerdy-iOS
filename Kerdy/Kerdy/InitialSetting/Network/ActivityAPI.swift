//
//  ActivityAPI.swift
//  Kerdy
//
//  Created by 최다경 on 11/23/23.
//

import Foundation
import Moya

enum ActivityAPI {
    case getActivities
}

extension ActivityAPI: TargetType {
    var baseURL: URL { return URL(string: "https://dev.kerdy.kro.kr")! }
    
    var path: String {
        switch self {
        case .getActivities:
            return "/activities"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getActivities:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getActivities:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
