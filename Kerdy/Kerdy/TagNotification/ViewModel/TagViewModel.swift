//
//  TagViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/8/23.
//

import Foundation

import RxSwift
import RxRelay
import RxCocoa

import Moya

final class TagViewModel: ViewModelType {
    
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
        let tapRegisterButton: Signal<Void>
    }
    
    struct Output {
        
        let tagList: Driver<[TagSection]>
        let didRegisterButtonTap: Signal<Void>
    }
    
    private let tagList = BehaviorRelay<[TagSection]>(value: [])
    private let didRegisterButtonTap = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        let output = Output(tagList: tagList.asDriver(),
                            didRegisterButtonTap: didRegisterButtonTap.asSignal())
        
        input.viewWillAppear
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { [weak self] owner, _ in
                guard let self = self, let id = self.id else { return }
                owner.getAllTagsAndUserTags(id: id)
            }
            .disposed(by: disposeBag)
        
        input.tapRegisterButton
            .withLatestFrom(tagList.asDriver())
            .flatMap { sections -> Driver<[Int]> in
                let selectedIds = sections[0].items
                    .filter { $0.isSelected }
                    .map { $0.id }
                return Driver.just(selectedIds)
            }
            .drive(with: self) { owner, selectedIds in
                owner.postTags(id: selectedIds)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

extension TagViewModel {
    
    func getAllTagsAndUserTags(id: Int) {
        let allTags = tagManager.getAllTags()
        let userTags = tagManager.getUserTags(id: id)
        
        Single.zip(allTags, userTags)
            .subscribe(onSuccess: { [weak self] allTagsResponse, userTagsResponse in
                guard let self else { return }
                let allTagsSection = TagSection(items: allTagsResponse)
                
                let userTagIDs = Set(userTagsResponse.map { $0.id })
                
                let updatedItems = allTagsSection.items.map { tag in
                    var mutableTag = tag
                    mutableTag.isSelected = userTagIDs.contains(tag.id)
                    return mutableTag
                }
                let updatedTagSection = [TagSection(items: updatedItems)]
                self.tagList.accept(updatedTagSection)
                
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func postTags(id: [Int]) {
        tagManager.postTags(id: id)
            .subscribe(onSuccess: { response in
                dump(response)
                self.didRegisterButtonTap.accept(())
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func cellInfo(index: Int) -> TagSection.Item? {
        return tagList.value[0].items[index]
    }
    
    func updateSelectedItem(index: Int, isSelected: Bool) {
        
        var updatedBlockList = tagList.value[0].items
        var updatedItem = updatedBlockList[index]
        
        updatedItem.isSelected = !isSelected
        updatedBlockList[index] = updatedItem
        
        let updatedTagList = [TagSection(items: updatedBlockList)]
        tagList.accept(updatedTagList)
    }
}
