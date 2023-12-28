//
//  BlockAPI.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import Foundation

import Moya

enum BlockAPI {
    case getBlockList
    case deleteBlock(id: Int)
    case postBlock(id: Int)
}

extension BlockAPI: KerdyAPI {
    
    var domain: KerdyDomain {
        return .block
    }
    
    var urlPath: String {
        switch self {
        case .getBlockList, .postBlock:
            return ""
        case .deleteBlock(id: let id):
            return "/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBlockList:
            return .get
        case .deleteBlock:
            return .delete
        case .postBlock:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .postBlock(id: let id):
            return .requestParameters(parameters: ["blockMemberId": id], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case  .getBlockList, .deleteBlock, .postBlock:
            return .hasAccessToken
        }
    }
    
    var error: [Int: NetworkError]? {
        switch self {
        case .getBlockList, .deleteBlock, .postBlock:
            return nil
        }
    }
}
