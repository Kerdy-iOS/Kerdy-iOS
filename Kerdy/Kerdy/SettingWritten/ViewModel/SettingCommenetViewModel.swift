//
//  SettingCommenetViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import Foundation

import RxCocoa
import RxSwift

import Moya

final class SettingCommenetViewModel {
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    private let commentManager: CommentManager
    private let id = Int(KeyChainManager.loadMemberID())
    
    // MARK: - Init
    
    init(commentManager: CommentManager) {
        self.commentManager = commentManager
    }
    
    struct Input {
        let viewWillAppear: Driver<Bool>
    }
    
    struct Output {
        let commentsList: Driver<[Comment]>
    }
    
    private let commentsList = BehaviorRelay<[Comment]>(value: [])
    func transform(input: Input) -> Output {
        
        let output = Output(commentsList: commentsList.asDriver())
        
        input.viewWillAppear
            .drive(with: self) { owner, _ in
                guard let id = self.id else { return }
                owner.getUserComments(id: id)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

// MARK: - Methods

extension SettingCommenetViewModel {
    
    func getUserComments(id: Int) {
        commentManager.getUserComments(id: id)
            .map { response in
                Dictionary(grouping: response.flatMap { [$0.parentComment] + $0.childComments },
                           by: { $0.memberID })
            }
            .map { groupedComments in
                groupedComments.map(\.value).flatMap { $0 }
            }
            .subscribe(onSuccess: { [weak self] commentsList in
                guard let self else { return }
                self.commentsList.accept(commentsList)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }

}
