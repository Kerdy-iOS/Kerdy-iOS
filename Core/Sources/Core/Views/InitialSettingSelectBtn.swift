//
//  CategoryBtn.swift
//  Kerdy
//
//  Created by 최다경 on 11/9/23.
//

import UIKit

public class InitialSettingSelectBtn: UIButton {
    
    public init(target: Any?, action: Selector, title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



