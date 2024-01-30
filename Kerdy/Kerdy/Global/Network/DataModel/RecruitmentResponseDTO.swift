//
//  RecruitmentResponseDTO.swift
//  Kerdy
//
//  Created by 이동현 on 1/1/24.
//

import Foundation

struct RecruitmentResponseDTO: Codable {
    let postId: Int
    let content: String
    let updatedAt: String
    let member: Member
    let eventId: Int
    
    enum CodingKeys: String, CodingKey {
        case postId
        case content
        case updatedAt
        case member
        case eventId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.postId = try container.decode(Int.self, forKey: .postId)
        self.content = try container.decode(String.self, forKey: .content)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        self.member = try container.decode(Member.self, forKey: .member)
        self.eventId = try container.decode(Int.self, forKey: .eventId)
    }
}

struct Member: Codable {
    let id: Int
    let name: String
    let description: String
    let imageUrl: String
    let githubUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageUrl
        case githubUrl
    }
}
