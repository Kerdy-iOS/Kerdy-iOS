//
//  BlockListModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

struct BlockListModel: Hashable {
    
    var id = UUID()
    let userId: String
    let profile: UIColor
    
    static func dummy() -> [BlockListModel] {
        return [BlockListModel(userId: "kerdy", profile: .kerdyMain),
                BlockListModel(userId: "kerdy", profile: .kerdyMain),
                BlockListModel(userId: "kerdy", profile: .kerdyMain),
                BlockListModel(userId: "kerdy", profile: .kerdyMain),
                BlockListModel(userId: "kerdy", profile: .kerdyMain),
                BlockListModel(userId: "kerdy", profile: .kerdyMain)
        ]
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(id)
    }
    
    static func == (lhs: BlockListModel, rhs: BlockListModel) -> Bool {
        lhs.id == rhs.id
    }
}
