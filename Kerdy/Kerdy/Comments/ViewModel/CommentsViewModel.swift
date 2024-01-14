//
//  CommentsViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/17/23.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

import Moya

final class CommentsViewModel: ViewModelType {
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    private let commentsManager: CommentManager
    private var commentID: Int
    
    // MARK: - Init
    
    init(commentID: Int, commentsManager: CommentManager) {
        self.commentsManager = commentsManager
        self.commentID = commentID
    }
    
    struct Input {
        
        let viewWillAppear: Driver<Bool>
        let textField: Driver<String>
        let tapEnterButton: Driver<AlertType>
    }
    
    struct Output {
        
        let commentsList: Driver<[CommentsSection]>
    }
    
    private let commentsList = BehaviorRelay<([CommentsSection])>(value: [])
    private let feedID = BehaviorRelay<Int>(value: 0)
    private let parentID = BehaviorRelay<Int?>(value: 0)
    
    func transform(input: Input) -> Output {
        let output = Output(commentsList: commentsList.asDriver())
        
        input.viewWillAppear
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                owner.getDetailComments(commentID: self.commentID)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.tapEnterButton.asObservable(), input.textField.asObservable())
            .subscribe(with: self, onNext: { owner, data in
                let (alertType, text) = data
                switch alertType {
                case .plain:
                    let feedID = self.feedID.value
                    let parentID = self.parentID.value
                    let request = CommentsRequestDTO(content: text, feedId: feedID, parentId: parentID)
                    owner.postComments(request: request)
                    
                case .modify:
                    owner.patchComments(commentID: self.commentID, content: text)
                default: break
                }
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension CommentsViewModel {
    
    func getDetailComments(commentID: Int) {
        commentsManager.getDetailComments(commentID: commentID)
            .subscribe(onSuccess: { response in
                let commentsList = [CommentsSection(header: response.parentComment, items: response.childComments)]
                self.commentsList.accept(commentsList)
                self.feedID.accept(response.parentComment.feedID)
                self.parentID.accept(response.parentComment.commentID)
                
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func postComments(request: CommentsRequestDTO) {
        commentsManager.postComments(request: request)
            .subscribe(onSuccess: { response in
                guard let commentID = response.commentID else { return }
                self.getDetailComments(commentID: commentID)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func patchComments(commentID: Int, content: String) {
        commentsManager.patchComments(commentID: commentID, content: content)
            .subscribe(onSuccess: { response in
                dump(response)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func updateComments(index: IndexPath, isHeader: Bool) -> String {
        
        if isHeader {
            self.commentID = self.commentsList.value[index.section].header.commentID ?? 0
            return self.commentsList.value[index.section].header.content
        } else {
            self.commentID = self.commentsList.value[index.section].items[index.item].commentID ?? 0
            return self.commentsList.value[index.section].items[index.item].content
        }
    }
}
