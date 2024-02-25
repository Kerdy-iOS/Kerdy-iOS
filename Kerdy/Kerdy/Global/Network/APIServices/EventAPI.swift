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
    case getEvent(eventId: Int)
    case postRecruitment(eventId: Int, memberId: Int, content: String)
    case updateRecruitment(eventId: Int, postId: Int, content: String)
    case deleteRecruitment(eventId: Int, postId: Int)
    case getRecruitments(eventId: Int)
    case getRecruitment(eventId: Int, postId: Int)
    case getUserRecruitments(memberId: Int)
    case isAlreadyRecruited(eventId: Int, memberId: Int)
}
    
extension EventAPI: KerdyAPI {
    var domain: KerdyDomain {
        return .event
    }
    
    var urlPath: String {
        switch self {
        case .getEvents:
            return ""
        case .getEvent(eventId: let id):
            return "/\(id)"
        case .postRecruitment(eventId: let eventId, memberId: _, content: _):
            return "/\(eventId)/recruitment-posts"
        case .updateRecruitment(eventId: let eventId, postId: let postId, content: _):
            return "/\(eventId)/recruitment-posts/\(postId)"
        case .deleteRecruitment(eventId: let eventId, postId: let postId):
            return "/\(eventId)/recruitment-posts/\(postId)"
        case .getRecruitments(eventId: let eventId):
            return "/\(eventId)/recruitment-posts"
        case .getRecruitment(eventId: let eventId, postId: let postId):
            return "/\(eventId)/recruitment-posts/\(postId)"
        case .getUserRecruitments(memberId: _):
            return "/recruitment-posts"
        case .isAlreadyRecruited(eventId: let eventId, memberId: _):
            return "/\(eventId)/recruitment-posts/already-recruitment"
        }
    }
    
    var error: [Int: NetworkError]? {
        return nil
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getEvents, .getEvent, .getRecruitments, .getRecruitment, .isAlreadyRecruited:
            return .plain
        case .postRecruitment, .updateRecruitment, .deleteRecruitment, .getUserRecruitments:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getEvents, .getEvent, .getRecruitments, .getRecruitment, .getUserRecruitments, .isAlreadyRecruited:
            return .get
        case .postRecruitment:
            return .post
        case .updateRecruitment:
            return .put
        case .deleteRecruitment:
            return .delete
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
        case .getEvent:
            return .requestPlain
        case .postRecruitment(eventId: _, memberId: let memberId, content: let content):
            return .requestParameters(parameters: ["memberId" : memberId, "content": content], encoding: JSONEncoding.default)
        case .updateRecruitment(eventId: _, postId: _, content: let content):
            return .requestParameters(parameters: ["content": content], encoding: URLEncoding.default)
        case .deleteRecruitment:
            return .requestPlain
        case .getRecruitments:
            return .requestPlain
        case .getRecruitment:
            return .requestPlain
        case .getUserRecruitments(memberId: let memberId):
            return .requestParameters(parameters: ["member-id": memberId], encoding: URLEncoding.default)
        case .isAlreadyRecruited(eventId: _, memberId: let memberId):
            return .requestParameters(parameters: ["member-id": memberId], encoding: URLEncoding.default)
        }
    }
}

