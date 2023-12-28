//
//  NotificationViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/10/23.
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
    }
    
    struct Output {
        
        let tagList: Driver<[TagSection]>
    }
    
    private let tagList = BehaviorRelay<[TagSection]>(value: [])
    
    func transform(input: Input) -> Output {
        let output = Output(tagList: tagList.asDriver())
        
        input.viewWillAppear
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self, onNext: { owner, _ in
                guard let id = self.id else { return }
                owner.getTags(id: id)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension NotificationViewModel {
    
    private func updateTagList(with response: [TagsResponseDTO]) {
        let tagList = [TagSection(items: response)]
        self.tagList.accept(tagList)
    }

    func getTags(id: Int) {
        tagManager.getUserTags(id: id)
            .map { [TagSection(items: $0)] }
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
            .map { [TagSection(items: $0)] }
            .subscribe(onSuccess: { [weak self] updatedList in
                guard let self else { return }
                self.tagList.accept(updatedList)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }

}
