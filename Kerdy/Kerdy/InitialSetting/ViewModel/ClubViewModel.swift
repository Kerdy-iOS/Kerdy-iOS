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
    private let memberAPIProvider = MoyaProvider<RegisterMemberAPI>()
    private let disposeBag = DisposeBag()
    var clubActivities = PublishSubject<[ActivityModel]>()
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
        guard let buttonState = try? clubSelectedDict[button]?.value() else {
            return
        }
        
        if buttonState == true {
            clubSelectedDict[button]?.onNext(false)
        } else if buttonState == false {
            clubSelectedDict[button]?.onNext(true)
        }
    }
    
    func registerMember(memberInfo: MemberInfo, completion: @escaping (Result<Void, Error>) -> Void) {
        memberAPIProvider.rx.request(.postMember(memberInfo: memberInfo))
            .subscribe { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }.disposed(by: disposeBag)
    }
}
