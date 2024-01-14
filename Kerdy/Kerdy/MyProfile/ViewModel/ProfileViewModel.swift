//
//  ProfileViewModel.swift
//  Kerdy
//
//  Created by 최다경 on 12/24/23.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewModel {
    
    static let shared = ProfileViewModel()
    
    private let settingManager = SettingManager.shared
    
    private let myProfileManager = MyProfileManager.shared
    
    private let tagManager = TagManager.shared
    
    private let id = Int(KeyChainManager.loadMemberID())
    
    var memberInfo = BehaviorRelay<MemberProfileResponseDTO?>(value: nil)
    
    let memberProfile = BehaviorRelay<MemberProfileResponseDTO?>(value: nil)
    
    var myActivities = BehaviorRelay<[ActivityResponse]>(value: [])
    
    let myTags = BehaviorRelay<[TagsResponseDTO]>(value: [])
    
    let clubActivities = BehaviorRelay<[ActivityResponse]>(value: [])
    
    let eduActivities = BehaviorRelay<[ActivityResponse]>(value: [])
    
    private let description = BehaviorRelay<String>(value: "")
    
    let selectedActivities = BehaviorRelay<[Int]>(value: [])
    
    let allTags = BehaviorRelay<[TagsResponseDTO]>(value: [])
    
    let disposeBag = DisposeBag()
    
    init() {
        if let id = id {
            getMemberProfile(id: id)
        }
        getMyInterestingTags()
        getAllInterestingTags()
        getMyActivities()
        getAllActivities()
    }
    
    func getMemberProfile(id: Int) {
        settingManager.getMember(id: id)
            .subscribe(onSuccess: { [weak self] member in
                self?.memberInfo.accept(member)
                self?.memberProfile.accept(member)
            }, onFailure: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func putMemberDescription(description: String) -> Completable {
        return Completable.create { [weak self] completable in
            self?.myProfileManager.putDescription(description: description)
                .subscribe(
                    onCompleted: {
                        completable(.completed)
                        if let id = self?.id {
                            self?.getMemberProfile(id: id)
                        }
                    },
                    onError: { error in
                        completable(.error(error))
                    }
                )
                .disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }

    func deleteActivityTag(id: Int) -> Completable {
        return Completable.create { [weak self] completable in
            self?.myProfileManager.deleteActivityTag(id: id)
                .subscribe(
                    onCompleted: {
                        completable(.completed)
                        self?.getMyActivities()
                        self?.getAllActivities()
                    },
                    onError: { error in
                        completable(.error(error))
                    }
                )
                .disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
    
    func getMyActivities() {
        myProfileManager.getMyActivities()
            .subscribe(onSuccess: { [weak self] activities in
                self?.myActivities.accept(activities)
                self?.getAllActivities()
            }, onFailure: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }

    func getAllActivities() {
        myProfileManager.getAllActivities()
            .subscribe(onSuccess: { [weak self] activities in
                let myActivityIds = self?.myActivities.value.map { $0.id }
                
                let filteredActivities = activities.filter { !myActivityIds!.contains($0.id) }
                
                let clubActivities = filteredActivities.filter { $0.activityType == "동아리"}
                let eduActivities = filteredActivities.filter { $0.activityType == "교육"}
                
                self?.clubActivities.accept(clubActivities)
                self?.eduActivities.accept(eduActivities)
            }, onFailure: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }

    func postMyActivities(ids: [Int]) -> Completable {
        return Completable.create { [weak self] completable in
            self?.myProfileManager.postMyActivities(ids: ids)
                .subscribe(
                    onCompleted: {
                        completable(.completed)
                        if let id = self?.id {
                            self?.getMyActivities()
                        }
                        self?.selectedActivities.accept([])
                    },
                    onError: { error in
                        completable(.error(error))
                    }
                )
                .disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
    
    private func getAllInterestingTags() {
        tagManager.getAllTags()
            .subscribe(onSuccess: { [weak self] tags in
                let myTagIds = self?.myTags.value.map { $0.id }
                let filteredTags = tags.filter { !myTagIds!.contains($0.id) }
                self?.allTags.accept(filteredTags)
            }, onFailure: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func getMyInterestingTags() {
        if let id = id {
            tagManager.getUserTags(id: id)
                .subscribe(onSuccess: { [weak self] tags in
                    self?.myTags.accept(tags)
                }, onFailure: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    func postTag(ids: [Int]) -> Single<Bool> {
        let myTagIds: [Int] = myTags.value.map { $0.id }
        return tagManager.postTags(id: ids + myTagIds)
            .map { response in
                if response.isEmpty {
                    return false
                } else {
                    self.getMyInterestingTags()
                    self.getAllInterestingTags()
                    return true
                }
            }
            .catchAndReturn(false)
    }
    
    func deleteTag(id: Int) -> Single<Bool> {
        return Single<Bool>.create { [weak self] single in
            self?.tagManager.deleteTags(id: [id])
                .subscribe(onSuccess: { _ in
                    single(.success(true))
                    self?.getMyInterestingTags()
                    self?.getAllInterestingTags()
                }, onFailure: {_ in 
                    single(.success(false))
                })
                .disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
    
    func updateProfileImage(image: UIImage) -> Completable {
        return Completable.create { [weak self] completable in
            self?.myProfileManager.updateProfileImage(image: image)
                .subscribe(
                    onCompleted: {
                        completable(.completed)
                        if let id = self?.id {
                            self?.getMemberProfile(id: id)
                        }
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
}
