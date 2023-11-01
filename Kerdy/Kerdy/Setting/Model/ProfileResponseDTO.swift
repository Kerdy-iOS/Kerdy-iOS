//
//  ProfileResponseDTO.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit

struct ProfileResponseDTO: Hashable {
    
    let id: String
    let email: String
    var image: UIImage? = nil
    
    static func dummy() -> ProfileResponseDTO {
        return .init(id: "hhh", email: "hhh@hhh.hhh", image: UIImage(systemName: "chevron.forward.circle.fill"))
    }
}
