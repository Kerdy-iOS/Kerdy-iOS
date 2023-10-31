//
//  TabBarItemType.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit


enum TabBarItemType: Int, CaseIterable {
    case myCard
    case event
    case chat
    case setting
}

extension TabBarItemType {
    var selectedIcon: UIImage {
        switch self {
        case .myCard:
            return .mycardOn
        case .event:
            return .eventOn
        case .chat:
            return .chatOn
        case .setting:
            return .settingOn
        }
    }
    
    var unselectedIcon: UIImage {
        switch self {
        case .myCard:
            return .mycardOff
        case .event:
            return .eventOff
        case .chat:
            return .chatOff
        case .setting:
            return .settingOff
        }
    }
    
    public func setTabBarItem() -> UITabBarItem {
        return UITabBarItem(
            title: nil,
            image: unselectedIcon,
            selectedImage: selectedIcon
        )
    }
}
