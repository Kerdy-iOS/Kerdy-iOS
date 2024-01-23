//
//  ArchiveSectionItem.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/7/24.
//

import RxDataSources
import Foundation

enum ArchiveSectionModel {
    case new(title: String = "새로운 알림", items: [ArchiveSectionItem])
    case old(title: String = "지난 알림", items: [ArchiveSectionItem])
}

enum ArchiveSectionItem {
    case new(ArchiveResponseDTO)
    case old(ArchiveResponseDTO)
}

extension ArchiveSectionModel: SectionModelType {
    typealias Item = ArchiveSectionItem
    
    var items: [ArchiveSectionItem] {
        switch self {
        case .new(_, let items), .old(_, let items):
            return items
        }
    }
    
    init(original: ArchiveSectionModel, items: [Item]) {
        switch original {
        case let .new(title, _):
            self = .new(title: title, items: items)
        case let .old(title, _):
            self = .old(title: title, items: items)
        }
    }
}

extension ArchiveSectionModel {
    var title: String {
        switch self {
        case .new(let title, _), .old(let title, _):
            return title
        }
    }
}
