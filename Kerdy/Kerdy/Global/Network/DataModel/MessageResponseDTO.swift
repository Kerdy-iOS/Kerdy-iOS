//
//  MessageResponseDTO.swift
//  Kerdy
//
//  Created by 이동현 on 2/25/24.
//

import Foundation

struct MessageResponseDTO: Codable {
    let roomId: String
    
    enum CodingKeys: CodingKey {
        case roomId
    }
}
