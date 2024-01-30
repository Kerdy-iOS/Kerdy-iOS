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
    
    private let tagManager = TagManager.shared
    private let id = Int(KeyChainManager.loadMemberID())
    
    struct Input {
        let viewWillAppear: Driver<Bool>
    }
    
    struct Output {
        let tagList: Driver<[NotificationCellItem]>
    }
    
    private let isSelectedRelay = BehaviorRelay<Bool>(value: UserDefaultStore.isSelected)
    private let tagList = BehaviorRelay<[NotificationCellItem]>(value: [])
    
    func transform(input: Input) -> Output {
        
        let output = Output(tagList: tagList.asDriver())
        
        let combinedSwitchSignal = Observable.merge(input.viewWillAppear.asObservable(), isSelectedRelay.asObservable())
        
        combinedSwitchSignal
            .asDriver(onErrorJustReturn: Bool())
            .drive(with: self) { owner, _ in
                guard let id = self.id else { return }
                owner.isSelectedRelay.value ? owner.getTags(id: id) : owner.tagList.accept([])
            }
            .disposed(by: disposeBag)
        
        return output
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
    
    func updateIsSelected(_ isSelected: Bool) {
        if isSelectedRelay.value != isSelected {
            isSelectedRelay.accept(isSelected)
            UserDefaultStore.isSelected = isSelected
        }
    }
}
