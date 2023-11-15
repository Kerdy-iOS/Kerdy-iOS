//
//  educationViewModel.swift
//  Kerdy
//
//  Created by 최다경 on 11/12/23.
//

import UIKit
import RxSwift

class EducationViewModel {
    let selectCount = BehaviorSubject<Int>(value: 0)
    
    var educationSelectedDict: [UIButton: BehaviorSubject<Bool>] = [:]
    
    func educationButtonTapped(button: UIButton) {
        guard let buttonState = try? educationSelectedDict[button]?.value(),
              let count = try? selectCount.value() else {
            return
        }
        
        if buttonState == true {
            educationSelectedDict[button]?.onNext(false)
            selectCount.onNext(count - 1)
        } else if buttonState == false, count < 4 {
            educationSelectedDict[button]?.onNext(true)
            selectCount.onNext(count + 1)
        }
    }
}
