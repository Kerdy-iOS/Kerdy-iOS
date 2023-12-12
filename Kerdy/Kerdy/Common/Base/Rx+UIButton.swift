//
//  Rx+UIButton.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    public var isSelected: ControlProperty<Bool> {
        return base.rx.controlProperty(
            editingEvents: [.touchUpInside],
            getter: { $0.isSelected },
            setter: { $0.isSelected = $1 })
    }
}
