//
//  BlockListModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import RxDataSources

struct BlockSection {
    var items: [Item]
}

extension BlockSection: SectionModelType {
    typealias Item = BlockReponseDTO
    
    init(original: BlockSection, items: [BlockReponseDTO]) {
        self = original
        self.items = items
    }
}
