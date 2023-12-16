//
//  Event.swift
//  Temp
//
//  Created by 이동현 on 10/29/23.
//

import Foundation

struct Event: Codable {
    let id: Int
    let name: String
    let informationUrl: String
    let startDate: String
    let endDate: String
    let applyStartDate: String
    let applyEndDate: String
    let location: String
    let tags: [String]
    let thumbnailUrl: String?
    let type: String
    let imageUrls: [String]
    let organization: String
    let paymentType: String
    let eventMode: String
}

func parseEvents(data: Data) throws -> [Event] {
    let decoder = JSONDecoder()
    return try decoder.decode([Event].self, from: data)
}
