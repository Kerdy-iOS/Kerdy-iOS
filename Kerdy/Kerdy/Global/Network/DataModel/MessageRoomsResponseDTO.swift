//
//  MessageRoomsResponseDTO.swift
//  Kerdy
//
//  Created by 이동현 on 2/25/24.
//

import Foundation

struct MessageRoomsResponseDTO: Codable {
    let roomId: String
    let interlocutor: Sender
    let recentlyMessage: RecentlyMessage

    enum CodingKeys: String, CodingKey {
        case roomId
        case interlocutor
        case recentlyMessage
    }
}

struct RecentlyMessage: Codable {
    let id: Int
    let sender: Sender
    let content: String
    let createdAt: String
    
    enum CodingKeys: CodingKey {
        case id
        case sender
        case content
        case createdAt
    }
}
