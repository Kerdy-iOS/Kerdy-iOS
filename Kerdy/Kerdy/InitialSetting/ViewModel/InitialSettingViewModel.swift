//
//  InitialSettingViewModel.swift
//  Kerdy
//
//  Created by 최다경 on 1/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class InitialSettingViewModel {
    
    static let shared = InitialSettingViewModel()
    
    private let id = Int(KeyChainManager.loadMemberID())
    
    private let settingManager = SettingManager.shared
    
    private let myProfileManager = MyProfileManager.shared
    
    var userName: String = ""
    
    var memberInfo = BehaviorRelay<MemberProfileResponseDTO?>(value: nil)
    
    var myActivities = BehaviorRelay<[ActivityResponse]>(value: [])
    
    let clubActivities = BehaviorRelay<[ActivityResponse]>(value: [])
    
    let eduActivities = BehaviorRelay<[ActivityResponse]>(value: [])
    
    let jobActivities = BehaviorRelay<[ActivityResponse]>(value: [])
    
    let selectedActivities = BehaviorRelay<[Int]>(value: [])
    
    let selectedCategory = BehaviorRelay<[Int]>(value: [])
    
    let disposeBag = DisposeBag()
 
    init() {

    }
    
    func getAllActivities() {
        myProfileManager.getAllActivities()
            .subscribe(onSuccess: { [weak self] activities in
                let myActivityIds = self?.myActivities.value.map { $0.id }
                
                let filteredActivities = activities.filter { !myActivityIds!.contains($0.id) }
                
                let clubActivities = filteredActivities.filter { $0.activityType == "동아리"}
                let eduActivities = filteredActivities.filter { $0.activityType == "교육"}
                let jobActivities = filteredActivities.filter { $0.activityType == "직무"}
                
                self?.clubActivities.accept(clubActivities)
                self?.eduActivities.accept(eduActivities)
                self?.jobActivities.accept(jobActivities)
            }, onFailure: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func postInitialMember(ids: [Int], name: String) -> Completable{
        return Completable.create { [weak self] completable in
            self?.myProfileManager.postInitialMember(ids: ids, name: name)
                .subscribe(
                    onCompleted: {
                        completable(.completed)
                    },
                    onError: { error in
                        completable(.error(error))
                    }
                )
                .disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
    
    func toggleSelectedTag(id: Int) -> Bool {
        var updatedTags = selectedActivities.value
        if updatedTags.contains(id) {
            updatedTags.removeAll { $0 == id }
        } else {
            updatedTags.append(id)
        }

        selectedActivities.accept(updatedTags)
        return selectedActivities.value.contains(id)
    }
    
    func toggleSelectedCategory(id: Int) -> Bool {
        var updatedTags = selectedCategory.value
        if updatedTags.contains(id) {
            updatedTags.removeAll { $0 == id }
        } else {
            updatedTags.append(id)
        }

        selectedCategory.accept(updatedTags)
        return selectedCategory.value.contains(id)
    }
    
}
