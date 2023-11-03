//
//  DivideLine.swift
//  
//
//  Created by 이동현 on 11/2/23.
//

import UIKit

public class DivideLine: UIView {
    public init(frame: CGRect, backgroundColor: UIColor) {
        super.init(frame: frame)
        setUp(backgroundColor: backgroundColor)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp(backgroundColor: backgroundColor ?? .black)
    }

    private func setUp(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
}
