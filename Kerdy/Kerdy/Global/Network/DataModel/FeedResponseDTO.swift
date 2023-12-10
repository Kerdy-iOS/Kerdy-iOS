//
//  FeedResponseDTO.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import Foundation

// MARK: - FeedResponseDTOElement

struct FeedResponseDTO: Codable {
    
    var uuid = UUID()
    let id, eventID: Int
    let title, content: String
    let writer: Writer
    let images: [String]
    let commentCount: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "eventId"
        case title, content, writer, images, commentCount, createdAt, updatedAt
    }
}

// MARK: - Writer

struct Writer: Codable {
    let id: Int
    let name, description, imageURL, githubURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case imageURL = "imageUrl"
        case githubURL = "githubUrl"
    }
}
