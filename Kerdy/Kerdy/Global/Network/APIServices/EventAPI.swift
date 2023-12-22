//
//  EventAPI.swift
//  Kerdy
//
//  Created by 이동현 on 12/14/23.
//

import Foundation
import Moya

enum EventAPI {
    case getEvents(category: String?, filter: EventFilter)
}

extension EventAPI: KerdyAPI {
    
    var domain: KerdyDomain {
        return .event
    }
    
    var urlPath: String {
        switch self {
        case .getEvents:
            return ""
        }
    }
    
    var error: [Int: NetworkError]? {
        switch self {
        case .getEvents:
            return nil
        }
    }
    
    var task: Task {
        switch self {
        case .getEvents(category: let category, filter: let filter):
            var parameters: [String: Any] = [:]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let category = category {
                parameters.updateValue(category, forKey: "category")
            }
            if let startDate = filter.startDate {
                let start = dateFormatter.string(from: startDate)
                parameters.updateValue(start, forKey: "startDate")
            }
            if let endDate = filter.endDate {
                let end = dateFormatter.string(from: endDate)
                parameters.updateValue(end, forKey: "endDate")
            }
            if let statuses = filter.statuses {
                parameters.updateValue(statuses, forKey: "statuses")
            }
            if let keyword = filter.keyword {
                parameters.updateValue(keyword, forKey: "keyword")
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getEvents:
            return .get
        }
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getEvents:
            return .plain
        }
    }
}
