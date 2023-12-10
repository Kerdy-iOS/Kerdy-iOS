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
    
}
