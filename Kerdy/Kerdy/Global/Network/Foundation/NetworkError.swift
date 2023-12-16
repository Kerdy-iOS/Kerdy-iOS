//
//  NetworkError.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/26/23.
//

import Foundation

enum NetworkError: Int {
    case invalidRequest = 400   // Bad Request, 토큰 유효하지 않은 경우
    case serverError    = 500   // Internal Server Error
}
