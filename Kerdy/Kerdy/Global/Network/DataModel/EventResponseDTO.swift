//
//  Event.swift
//  Temp
//
//  Created by 이동현 on 10/29/23.
//

import Foundation

struct EventResponseDTO: Codable, Equatable {
    
    let id: Int
    let name: String
    let informationUrl: String
    let startDate: String
    let endDate: String
    let applyStartDate: String
    let applyEndDate: String
    let location: String
    let tags: [Tag]
    let thumbnailUrl: String?
    let type: String
    let imageUrls: [String]
    let organization: String
    let paymentType: String
    let eventMode: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, informationUrl
        case startDate, endDate, applyStartDate, applyEndDate
        case location, tags, type, organization, paymentType, eventMode
        case thumbnailUrl, imageUrls
    }
    
    static func == (lhs: EventResponseDTO, rhs: EventResponseDTO) -> Bool {
        lhs.id == rhs.id
    }
}

struct Tag: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

