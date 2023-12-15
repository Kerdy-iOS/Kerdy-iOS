//
//  BlockReponseDTO.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import Foundation

struct BlockReponseDTO: Decodable, Equatable {
    
    var uuid = UUID()
    let id: Int
    let memberID: Int
    let imageURL: String?
    let name: String
    var isSelected: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, isSelected
        case memberID = "blockMemberId"
        case imageURL = "imageUrl"
        case name = "memberName"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.isSelected = (try? container.decode(Bool.self, forKey: .isSelected)) ?? true
        self.memberID = try container.decode(Int.self, forKey: .memberID)
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    static func == (lhs: BlockReponseDTO, rhs: BlockReponseDTO) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
