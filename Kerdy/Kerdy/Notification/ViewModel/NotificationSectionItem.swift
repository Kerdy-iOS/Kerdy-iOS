//
//  NotificationSectionItem.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/22/23.
//

import Foundation

enum NotificationSection: Hashable {
    
    case main
}

enum NotificationItem: Hashable, Equatable {
    
    case header(Bool)
    case cellItem(NotificationCellItem)
}

struct NotificationCellItem: Hashable, Equatable {

    let tagList: [TagsResponseDTO]
}
