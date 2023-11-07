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
        guard let buttonState = try? categorySelectedDict[button]?.value(),
              let count = try? selectCount.value() else {
            return
        }
        
        if buttonState == true {
            categorySelectedDict[button]?.onNext(false)
            selectCount.onNext(count - 1)
        } else if buttonState == false, count < 4 {
            categorySelectedDict[button]?.onNext(true)
            selectCount.onNext(count + 1)
        }
    }
}

