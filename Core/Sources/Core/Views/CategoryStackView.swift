//
//  File.swift
//  
//
//  Created by 최다경 on 11/9/23.
//

import UIKit

public class CategoryStackView: UIStackView {
    convenience init() {
        self.init(frame: .zero)
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .fill
        self.spacing = 8
    }
}
