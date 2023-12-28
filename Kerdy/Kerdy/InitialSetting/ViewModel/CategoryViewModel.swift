//
//  CategoryViewModel.swift
//  Kerdy
//
//  Created by 최다경 on 11/5/23.
//

import UIKit
import RxSwift
import Moya

class CategoryViewModel {
    
    private let provider = MoyaProvider<ActivityAPI>()
    private let disposeBag = DisposeBag()
    var jobActivities = PublishSubject<[ActivityModel]>()
    let selectCount = BehaviorSubject<Int>(value: 0)
    var categorySelectedDict: [UIButton: BehaviorSubject<Bool>] = [:]
    
    func fetchActivities() {
        provider.rx.request(.getActivities)
            .map([ActivityModel].self, using: JSONDecoder(), failsOnEmptyData: false)
            .subscribe { result in
                switch result {
                case .success(let activities):
                    let jobActivities = activities.filter { $0.activityType == "직무" }
                    self.jobActivities.onNext(jobActivities)
                case .failure(let error):
                    print(error)
                }
            }.disposed(by: disposeBag)
    }
    
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
