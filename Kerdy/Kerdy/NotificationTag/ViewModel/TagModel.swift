//
//  TagModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import Foundation

struct TagType {
    
    let title: String
    
    static func dummy() -> [TagType] {
        return [TagType(title: "Android"),
                TagType(title: "iOS"),
                TagType(title: "Frontend"),
                TagType(title: "Backend"),
                TagType(title: "AI")
        ]
    }
}
