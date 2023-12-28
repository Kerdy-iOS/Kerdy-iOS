//
//  CommentsSection.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/18/23.
//

import RxDataSources

struct CommentsSection {
    var header: Comment
    var items: [Comment]
}

extension CommentsSection: SectionModelType {
    init(original: CommentsSection, items: [Comment]) {
        self = original
        self.items = items
    }
}
