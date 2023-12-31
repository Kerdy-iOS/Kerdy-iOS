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
    
    var error: [Int : NetworkError]? {
        switch self {
        case .getEvents:
            return nil
        }
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getEvents:
            return .plain
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getEvents:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getEvents(category: let category, filter: let filter):
            var parameters: [String: Any] = [:]
            
            if let category = category {
                parameters.updateValue(category, forKey: "category")
            }
            if let startDate = filter.startDate {
                parameters.updateValue(startDate, forKey: "startDate")
            }
            if let endDate = filter.endDate {
                parameters.updateValue(endDate, forKey: "endDate")
            }
            if
                let statuses = filter.statuses,
                statuses.count > 0
            {
                let statuses = statuses.joined(separator: ",")
                parameters.updateValue(statuses, forKey: "statuses")
            }
            if let keyword = filter.keyword {
                parameters.updateValue(keyword, forKey: "keyword")
            }
            if
                let tags = filter.tags,
                tags.count > 0
            {
                let tags = tags.joined(separator: ",")
                parameters.updateValue(tags, forKey: "tags")
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}
