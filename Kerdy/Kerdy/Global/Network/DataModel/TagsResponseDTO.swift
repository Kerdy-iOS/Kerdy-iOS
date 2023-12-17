//
//  TagsResponseDTO.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/8/23.
//

import Foundation

// MARK: - TagsResponseDTO

struct TagsResponseDTO: Decodable, Equatable {
    
    let id: Int
    let name: String
    var isSelected: Bool
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case isSelected
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.isSelected = (try? container.decode(Bool.self, forKey: .isSelected)) ?? false
    }
}
