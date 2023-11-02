//
//  File.swift
//  
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

@available(iOS 15.0, *)
public extension UIButton {
    
    static func kerdyStyle(to title: String,
                           withBackground backgroundColor: UIColor? = .clear,
                           withForeground foregroundColor: UIColor? = .kerdy_black,
                           withStroke strokeColor: UIColor? = .kerdy_gray01,
                           using width: CGFloat = 0.5,
                           font: UIFont? = UIFont.nanumSquare(to: .regular, size: 11)
    ) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.titleAlignment = .center
        configuration.background.backgroundColor = backgroundColor
        configuration.baseForegroundColor = foregroundColor
        configuration.background.cornerRadius = 10
        configuration.background.strokeWidth = width
        configuration.background.strokeColor = strokeColor
        configuration.attributedTitle =  AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : font!]))
        
        return configuration
    }
}
