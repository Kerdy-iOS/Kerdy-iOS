//
//  BlockListViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

import Moya

final class BlockListViewModel: ViewModelType {
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    private let blockManager = BlockManager.shared

    struct Input {
        
        let viewWillAppear: Driver<Bool>
    }
    
    struct Output {
        
        let blockList: Driver<[BlockSection]>
    }
    
    private let blockList = BehaviorRelay<[BlockSection]>(value: [])
    private var selectedItems: [Int: Bool] = [:]
    
    func transform(input: Input) -> Output {
        
        let output = Output(blockList: blockList.asDriver())
        
        input.viewWillAppear
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self, onNext: { owner, _ in
                owner.getBlockList()
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension BlockListViewModel {
    
    func getBlockList() {
        blockManager.getBlockList()
            .map { [BlockSection(items: $0)] }
            .subscribe(onSuccess: { [weak self] blockList in
                guard let self else { return }
                self.blockList.accept(blockList)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func postBlock(id: Int) {
        blockManager.postBolck(id: id)
            .subscribe(onSuccess: { response in
                dump(response)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteBlock(id: Int) {
        blockManager.deleteBlock(id: id)
            .subscribe(onSuccess: { response in
                dump(response)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func cellInfo(index: Int) -> BlockSection.Item? {
        
        return blockList.value[0].items[index]
    }
    
    func updateSelectedItem(index: Int, isSelected: Bool) {
        
        var updatedBlockList = blockList.value
        var updatedItem = updatedBlockList[0].items[index]
        updatedItem.isSelected = isSelected
        updatedBlockList[0].items[index] = updatedItem
        blockList.accept(updatedBlockList)
    }
    
    func delegeBlockMember(blockID: Int? = nil) {
        if let blockID = blockID {
            self.deleteBlock(id: blockID)
        }
    }
}
