//
//  EventAPI.swift
//  Kerdy
//
//  Created by 이동현 on 12/14/23.
//

import Foundation
import Moya

enum EventAPI {
    case getEvents(
        category: String?,
        startDate: Date?,
        endDate: Date?,
        statuses: [String]?,
        keyword: String?
    )
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

    var parameters: [String : Any]? {
        switch self {
        case .getEvents(
            category: let category,
            startDate: let startDate,
            endDate: let endDate,
            statuses: let statuses,
            keyword: let keyword
        ):
            var parameters: [String: Any] = [:]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
        
            if let category = category {
                parameters.updateValue(category, forKey: "category")
            }
            if let startDate = startDate {
                let start = dateFormatter.string(from: startDate)
                parameters.updateValue(start, forKey: "startDate")
            }
            if let endDate = endDate {
                let end = dateFormatter.string(from: endDate)
                parameters.updateValue(end, forKey: "endDate")
            }
            if let statuses = statuses {
                parameters.updateValue(statuses, forKey: "statuses")
            }
            if let keyword = keyword {
                parameters.updateValue(keyword, forKey: "keyword")
            }
            return parameters
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getEvents:
            return .get
        }
    }
}
    
