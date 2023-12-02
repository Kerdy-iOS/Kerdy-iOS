//
//  ClubViewModel.swift
//  Kerdy
//
//  Created by 최다경 on 11/12/23.
//

import UIKit
import RxSwift
import Moya

class ClubViewModel {
    
    private let provider = MoyaProvider<ActivityAPI>()
    private let disposeBag = DisposeBag()
    var clubActivities = PublishSubject<[ActivityModel]>()
    let selectCount = BehaviorSubject<Int>(value: 0)
    var clubSelectedDict: [UIButton: BehaviorSubject<Bool>] = [:]
    
    func fetchActivities() {
        provider.rx.request(.getActivities)
            .map([ActivityModel].self, using: JSONDecoder(), failsOnEmptyData: false)
            .subscribe { result in
                switch result {
                case .success(let activities):
                    let clubActivities = activities.filter { $0.activityType == "동아리" }
                    self.clubActivities.onNext(clubActivities)
                case .failure(let error):
                    print(error)
                }
            }.disposed(by: disposeBag)
    }
    
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
