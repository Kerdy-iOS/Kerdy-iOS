//
//  ReportAPI.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/11/24.
//

import Foundation

import Moya

enum ReportType: String, CaseIterable, Codable {
    case COMMENT, PARTICIPANT, REQUEST_NOTIFICATION
}

struct ReportRequestDTO: Codable {
    let reporterId: Int
    let reportedId: Int
    let type: ReportType
    let contentId: Int
}

enum ReportAPI {
    case postReport(request: ReportRequestDTO)
}

extension ReportAPI: KerdyAPI {
    
    var domain: KerdyDomain {
        return .report
    }
    
    var urlPath: String {
        switch self {
        case .postReport:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postReport:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .postReport(request: let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .postReport:
            return .hasAccessToken
        }
    }

    var error: [Int: NetworkError]? {
        switch self {
        case .postReport:
            return nil
        }
    }
}
