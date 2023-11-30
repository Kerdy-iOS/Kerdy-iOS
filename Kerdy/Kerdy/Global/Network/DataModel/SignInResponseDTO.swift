//
//  LoginResponseDTO.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/26/23.
//

import Foundation

struct SignInResponseDTO: Decodable {
    
    let id: Int
    let onboarded: Bool
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case id = "memberId"
        case onboarded, accessToken
    }
}
