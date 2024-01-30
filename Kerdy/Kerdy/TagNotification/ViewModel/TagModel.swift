//
//  TagModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import RxDataSources

struct TagSection {
    var items: [Item]
}

extension TagSection: SectionModelType {
    typealias Item = TagsResponseDTO
    
    init(original: TagSection, items: [TagsResponseDTO]) {
        self = original
        self.items = items
    }
}
