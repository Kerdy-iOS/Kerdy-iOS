//
//  File.swift
//  
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

public extension UITabBar {
    
    func configureTabBar() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.clear
    }
}
