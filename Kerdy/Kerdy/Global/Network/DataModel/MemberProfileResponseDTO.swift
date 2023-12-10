//
//  MemberProfileResponseDTO.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/1/23.
//

import Foundation

// MARK: - MemberProfileResponseDTO

struct MemberProfileResponseDTO: Decodable, Equatable {

    var uuid = UUID()
    let id: Int
    let name: String?
    let description: String
    let imageURL, githubURL: String
    let activities: [Activity]

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case imageURL = "imageUrl"
        case githubURL = "githubUrl"
        case activities
    }

    static func == (lhs: MemberProfileResponseDTO, rhs: MemberProfileResponseDTO) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    static func empty() -> MemberProfileResponseDTO {
        return MemberProfileResponseDTO(id: 0, name: nil, description: "", imageURL: "", githubURL: "", activities: [])
    }
}

// MARK: - Activity

struct Activity: Codable, Equatable {
    let id: Int
    let name, activityType: String
}
