//
//  RegisterMemberAPI.swift
//  Kerdy
//
//  Created by 최다경 on 12/3/23.
//

import Foundation
import Moya

enum RegisterMemberAPI {
    case postMember(memberInfo: MemberInfo)
}

extension RegisterMemberAPI: TargetType {
    var baseURL: URL { return URL(string: "https://dev.kerdy.kro.kr")! }
    
    var path: String {
        switch self {
        case .postMember:
            return "/members"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postMember:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .postMember(let memberInfo):
            return .requestJSONEncodable(memberInfo)
        }
    }

    var headers: [String: String]? {
        //토큰 추가 예정
        return ["Content-Type": "application/json",
                "Authorization": "Bearer AccessToken "]
    }
}
