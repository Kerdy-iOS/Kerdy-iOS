//
//  File.swift
//  
//
//  Created by 최다경 on 12/14/23.
//

import UIKit

public class InitialSettingSelectBtn: UIButton {
    
    public var id: Int?
    
    public init(target: Any?, action: Selector, title: String, id: Int) {
        super.init(frame: .zero)
        self.id = id
        self.setTitle(title, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
