//
//  ClubViewModel.swift
//  Kerdy
//
//  Created by 최다경 on 11/12/23.
//

import UIKit
import RxSwift

class ClubViewModel {
    let selectCount = BehaviorSubject<Int>(value: 0)
    
    var clubSelectedDict: [UIButton: BehaviorSubject<Bool>] = [:]
    
    func clubButtonTapped(button: UIButton) {
        guard let buttonState = try? clubSelectedDict[button]?.value(),
              let count = try? selectCount.value() else {
            return
        }
        
        if buttonState == true {
            clubSelectedDict[button]?.onNext(false)
            selectCount.onNext(count - 1)
        } else if buttonState == false, count < 4 {
            clubSelectedDict[button]?.onNext(true)
            selectCount.onNext(count + 1)
        }
    }
}
