//
//  MessageRoomResponseDTO.swift
//  Kerdy
//
//  Created by 이동현 on 1/21/24.
//

import Foundation

struct MessageRoomResponseDTO: Codable {
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

// MARK: - Sender
struct Sender: Codable {
    let id: Int
    let name: String
    let description: String
    let imageURL: String
    let githubURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case imageURL = "imageUrl"
        case githubURL = "githubUrl"
    }
}
