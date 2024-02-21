//
//  MyProfileAPI.swift
//  Kerdy
//
//  Created by 최다경 on 1/4/24.
//

import UIKit
import Moya

enum MyProfileAPI {
    case description(description: String)
    case deleteInterestTag(ids: [Int])
    case deleteActivityTag(id: Int)
    case getMyActivities
    case getAllActivities
    case postMyActivities(ids: [Int])
    case updateProfileImage(image: MultipartFormData)
    case postInitialMember(ids: [Int], name: String)
}

extension MyProfileAPI: KerdyAPI {
    
    var domain: KerdyDomain {
        switch self {
        case .getAllActivities:
            return .activity
        default:
            return .member
        }
    }
    
    var urlPath: String {
        switch self {
        case .description:
            return "/description"
        case .deleteInterestTag:
            return "/interest-tags"
        case .deleteActivityTag, .postMyActivities:
            return "/activities"
        case .getMyActivities:
            return "/\(KeyChainManager.loadMemberID())/activities"
        case .getAllActivities, .postInitialMember:
            return ""
        case .updateProfileImage:
            return "/\(KeyChainManager.loadMemberID())/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .description:
            return .put
        case .deleteInterestTag, .deleteActivityTag:
            return .delete
        case .getMyActivities, .getAllActivities:
            return .get
        case .postMyActivities, .postInitialMember:
            return .post
        case .updateProfileImage:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case let .description(description):
            let parameters: [String: Any] = ["description": description]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .deleteInterestTag(ids: let ids):
            let parameters: [String: [Any]] = ["tagIds": ids]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .deleteActivityTag(id: let id):
            let parameters: [String: Any] = ["activity-ids": "\(id)"]
           return .requestParameters(
            parameters: parameters,
            encoding: URLEncoding.queryString
           )
        case .getMyActivities, .getAllActivities:
            return .requestPlain
        case .postMyActivities(ids: let ids):
            let parameters = ["activityIds": ids]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .updateProfileImage(image: let image):
            return .uploadMultipart([image])
        case .postInitialMember(ids: let ids, name: let name):
            let parameters: [String: Any] = [
                "name": name,
                "activityIds": ids as [Int]
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        }
    }

    var headerType: HTTPHeaderFields {
        switch self {
        case .description, .deleteActivityTag, .deleteInterestTag, .postMyActivities, .updateProfileImage, .postInitialMember:
            return .hasAccessToken
        case .getMyActivities, .getAllActivities:
            return .plain
        }
    }
    
    var error: [Int: NetworkError]? {
        switch self {
        default:
            return nil
        }
    }
}
