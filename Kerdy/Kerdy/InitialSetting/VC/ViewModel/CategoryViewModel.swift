//
//  CategoryViewModel.swift
//  Kerdy
//
//  Created by 최다경 on 11/5/23.
//

import UIKit
import RxSwift

class CategoryViewModel {
    let selectCount = BehaviorSubject<Int>(value: 0)
    
    var categorySelectedDict: [UIButton: BehaviorSubject<Bool>] = [:]
    
    func categoryButtonTapped(button: UIButton) {
        if let buttonState = try? categorySelectedDict[button]?.value() {
            if buttonState == true {
                categorySelectedDict[button]?.onNext(false)
                if let count = try? selectCount.value() {
                    selectCount.onNext(count - 1)
                }
            } else if buttonState == false, let count = try? selectCount.value(), count < 4 {
                categorySelectedDict[button]?.onNext(true)
                selectCount.onNext(count + 1)
            }
        }
    }
}

