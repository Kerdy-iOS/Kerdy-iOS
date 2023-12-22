//
//  TabBarVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit

import Core

final class TabBarVC: UITabBarController {

    // MARK: - Property
    
    private var tabs: [UIViewController] = []
    private lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTabBarItems()
        setTabBarUI()
    }

}

// MARK: - Methods

extension TabBarVC {
    
    func setTabBarItems() {
        tabs = [MyCardVC(),
                UINavigationController(rootViewController: EventVC()),
                ChatVC(),
                SettingVC(),
                UINavigationController(rootViewController: MyBusinessCardVC()) //테스트 위해 잠시 추가
        ]
        
        TabBarItemType.allCases.forEach {
            tabs[$0.rawValue].tabBarItem = $0.setTabBarItem()
            tabs[$0.rawValue].tabBarItem.tag = $0.rawValue
            tabs[$0.rawValue].tabBarItem.imageInsets = UIEdgeInsets.init(
                top: 10,
                left: 0,
                bottom: -10,
                right: 0
            )
        }
        
        setViewControllers(tabs, animated: false)
    }
    
    func setTabBarUI() {
        tabBar.configureTabBar()
        tabBar.backgroundColor = .kerdyBackground
        tabBar.tintColor = .kerdyMain
        tabBar.itemPositioning = .centered
        tabBar.layer.applyShadow()
    }
}
