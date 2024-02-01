//
//  NotificationViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/22/23.
//

import Foundation

import UserNotifications

import RxSwift
import RxRelay
import RxCocoa

import Moya

final class NotificationViewModel: ViewModelType {
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    
    private let tagManager = TagManager.shared
    private let id = Int(KeyChainManager.loadMemberID())
    
    struct Input {
        let viewWillAppear: Driver<Bool>
        let willEnterForegroundNotification: Observable<Notification>
    }
    
    struct Output {
        let tagList: Driver<([NotificationCellItem], Bool)>
    }
    
    private let isSelectedRelay = BehaviorRelay<Bool>(value: UserDefaultStore.isNotification)
    private let tagList = BehaviorRelay<[NotificationCellItem]>(value: [])
    private var defaultList: [NotificationCellItem] = []
    
    func transform(input: Input) -> Output {
        
        let tagListDriver = Driver.combineLatest(tagList.asDriver(), isSelectedRelay.asDriver()) { tagList, isSelected in
            return (tagList, isSelected)
        }
        
        let output = Output(tagList: tagListDriver)
        
        input.viewWillAppear
            .flatMapLatest { _ in
                return self.getAuthorizationStatus().asDriver(onErrorJustReturn: false)
            }
            .drive(with: self) { owner, status in
                self.getTagList(status: status)
            }
            .disposed(by: disposeBag)
        
        input.willEnterForegroundNotification
            .flatMapLatest { _ in
                return self.getAuthorizationStatus().asDriver(onErrorJustReturn: false)
            }
            .bind(with: self, onNext: { owner, status in
                owner.isSelectedRelay.accept(status)
                UserDefaultStore.isFirstNotification = status
                UserDefaultStore.isNotification = status
            })
            .disposed(by: disposeBag)
        
        isSelectedRelay
            .asDriver(onErrorJustReturn: false)
            .distinctUntilChanged()
            .drive(with: self, onNext: { owner, status in
                owner.tagList.accept(status ? owner.defaultList : [])
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension NotificationViewModel {
    
    private func getAuthorizationStatus() -> Observable<Bool> {
        return Observable.create { observer in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                observer.onNext(settings.authorizationStatus == .authorized)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    private func getTagList(status: Bool) {
        guard let id = self.id else { return }
        tagManager.getUserTags(id: id)
            .map { [NotificationCellItem(tagList: $0)] }
            .subscribe(onSuccess: { [weak self] updatedList in
                guard let self else { return }
                self.defaultList = updatedList
                self.tagList.accept(status && UserDefaultStore.isNotification ? updatedList: [])
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteTags(id: [Int]) {
        tagManager.deleteTags(id: id)
            .map { [NotificationCellItem(tagList: $0)] }
            .subscribe(onSuccess: { [weak self] updatedList in
                guard let self else { return }
                self.defaultList = updatedList
                self.tagList.accept(updatedList)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func updateIsSelected(_ isSelected: Bool) {
        UserDefaultStore.isNotification = isSelected
        isSelectedRelay.accept(isSelected)
    }
}
