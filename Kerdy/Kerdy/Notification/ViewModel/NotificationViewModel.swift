//
//  NotificationViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/22/23.
//

import Foundation

import RxSwift
import RxRelay
import RxCocoa

import Moya

final class NotificationViewModel: ViewModelType {
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    private let tagManager: TagManager
    private let id = Int(KeyChainManager.loadMemberID())
    
    // MARK: - Init
    
    init(tagManager: TagManager) {
        self.tagManager = tagManager
    }
    
    struct Input {
        
        let viewWillAppear: Driver<Bool>
        let switchValueChanged: Driver<Bool>
    }
    
    struct Output {
        
        let isSwitch: Driver<(Bool, [NotificationCellItem])>
    }
    
    private let switchValueRelay = BehaviorRelay<Bool>(value: false)
    private let tagList = BehaviorRelay<[NotificationCellItem]>(value: [])
    
    func transform(input: Input) -> Output {
        
        let isSwitch = Observable.combineLatest(switchValueRelay.asObservable(),
                                                tagList.asObservable())        
        input.viewWillAppear
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self, onNext: { owner, _ in
                guard let id = self.id else { return }
                owner.getTags(id: id)
            })
            .disposed(by: disposeBag)
        
        input.switchValueChanged
            .debug()
            .drive(switchValueRelay)
            .disposed(by: disposeBag)
        
        return Output(isSwitch: isSwitch.asDriver(onErrorJustReturn: (false, [])))
    }
}

extension NotificationViewModel {
    
    private func updateTagList(with response: [TagsResponseDTO]) {
        let tagList = [NotificationCellItem(tagList: response)]
        self.tagList.accept(tagList)
    }
    
    func getTags(id: Int) {
        tagManager.getUserTags(id: id)
            .map { [NotificationCellItem(tagList: $0)] }
            .subscribe(onSuccess: { [weak self] updatedList in
                guard let self else { return }
                self.tagList.accept(updatedList)
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
                self.tagList.accept(updatedList)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
}
