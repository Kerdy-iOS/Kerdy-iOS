//
//  NetworkError.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/26/23.
//

import Foundation

import Moya

enum NetworkError: Int {
    case invalidRequest = 400   // Bad Request, 토큰 유효하지 않은 경우
    case serverError    = 500   // Internal Server Error
}

struct HandleNetworkError {
    
    static func handleNetworkError(_ error: Error) {
        if let moyaError = error as? MoyaError {
            if let statusCode = moyaError.response?.statusCode {
                let networkError = NetworkError(rawValue: statusCode)
                switch networkError {
                case .invalidRequest:
                    print("invalidRequest")
                default:
                    print("network error")
                }
            }
        }
    }
}
