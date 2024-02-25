//
//  MessageRoomsResponseDTO.swift
//  Kerdy
//
//  Created by 이동현 on 2/25/24.
//

import Foundation

struct MessageRoomsResponseDTO: Codable, Equatable {
    let roomId: String
    let interlocutor: Sender
    let recentlyMessage: RecentlyMessage

    enum CodingKeys: String, CodingKey {
        case roomId
        case interlocutor
        case recentlyMessage
    }
    
    static func == (lhs: MessageRoomsResponseDTO, rhs: MessageRoomsResponseDTO) -> Bool {
        lhs.roomId == rhs.roomId
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
