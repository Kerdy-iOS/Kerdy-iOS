//
//  File.swift
//  
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

public extension UIButton {
    @available(iOS 15.0, *)
    
    static func kerdyStyle(to title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.titleAlignment = .center
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = .kerdy_black
        configuration.background.cornerRadius = 10
        configuration.background.strokeWidth = 0.5
        configuration.background.strokeColor = .kerdy_gray01
        configuration.attributedTitle =  AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.nanumSquare(to: .regular, size: 11)]))
        
        return configuration
    }
}
