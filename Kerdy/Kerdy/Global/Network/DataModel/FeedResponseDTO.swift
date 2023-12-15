//
//  ArticleResponseDTO.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/10/23.
//

import Foundation

// MARK: - FeedResponseDTOElement

struct FeedResponseDTO: Codable, Hashable, SettingWrittenProtocol {
    
    var uuid = UUID()
    let id, eventID: Int
    let title, content: String
    let writer: Writer
    let images: [String]
    let commentCount: Int
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, content
        case eventID = "eventId"
        case images, commentCount, createdAt, updatedAt, writer
    }
    
    static func == (lhs: FeedResponseDTO, rhs: FeedResponseDTO) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    var updateDate: String {
        if createdAt == updatedAt {
            return convertDate(date: createdAt)
        } else {
            return convertDate(date: updatedAt) + " 수정됨"
        }
    }
}

// MARK: - Writer

struct Writer: Codable, Hashable {
    
    let id: Int
    let name, description, imageURL, githubURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case imageURL = "imageUrl"
        case githubURL = "githubUrl"
    }
}
