//
//  CommonModalItem.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/26/24.
//

import UIKit

import RxDataSources

struct CommonModalItem: Equatable {
    
    let type: AlertType
    var titleColor: UIColor? = .kerdyBlack
    
    init(type: AlertType, titleColor: UIColor? = .kerdyBlack) {
        self.type = type
        self.titleColor = titleColor
    }
    
    static let reportModal: [CommonModalItem]  = [CommonModalItem(type: .report, titleColor: .kerdyRed)]
    static let basicModal: [CommonModalItem] = [CommonModalItem(type: .modify),
                                                CommonModalItem(type: .delete)]
}

struct CommonModalSectionItem {
    typealias Model = SectionModel<Section, Item>
    
    enum Section: Int, Equatable {
        case main
    }
    
    enum Item: Equatable {
        case report(CommonModalItem)
        case basic(CommonModalItem)
    }
}
