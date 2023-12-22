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

enum NotificationItem: Hashable {
    
    case header(UUID)
    case cellItem(NotificationCellItem)
    
}

struct NotificationCellItem: Hashable {
    
    let uuid = UUID()
    let tagList: [TagsResponseDTO]
}
