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
    
    enum CodingKeys: String, CodingKey {
        case id
        case memberID = "blockMemberId"
        case imageURL = "imageUrl"
        case name = "memberName"
    }
    
    static func == (lhs: BlockReponseDTO, rhs: BlockReponseDTO) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
