//
//  educationViewModel.swift
//  Kerdy
//
//  Created by 최다경 on 11/12/23.
//

import UIKit
import RxSwift
import Moya
import RxMoya

class EducationViewModel {
    
    private let provider = MoyaProvider<ActivityAPI>()
    private let disposeBag = DisposeBag()
    var educationActivities = PublishSubject<[ActivityModel]>()
    let selectCount = BehaviorSubject<Int>(value: 0)
    var educationSelectedDict: [UIButton: BehaviorSubject<Bool>] = [:]
    
    func fetchActivities() {
        provider.rx.request(.getActivities)
            .map([ActivityModel].self, using: JSONDecoder(), failsOnEmptyData: false)
            .subscribe { result in
                switch result {
                case .success(let activities):
                    let educationActivities = activities.filter { $0.activityType == "교육" }
                    self.educationActivities.onNext(educationActivities)
                case .failure(let error):
                    print(error)
                }
            }.disposed(by: disposeBag)
    }
    
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
