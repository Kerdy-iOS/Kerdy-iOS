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
    // 특정 comment-id
    init(commentID: Int, commentsManager: CommentManager) {
        self.commentsManager = commentsManager
        self.commentID = commentID
    }
    
    struct Input {
        
        let viewWillAppear: Driver<Bool>
    }
    
    struct Output {
        
        let commentsList: Driver<[CommentsSection]>
    }
    
    private let commentsList = BehaviorRelay<([CommentsSection])>(value: [])
    
    func transform(input: Input) -> Output {
        let output = Output(commentsList: commentsList.asDriver())
        
        input.viewWillAppear
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                owner.getDetailComments(commentID: self.commentID)
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
}

extension CommentsViewModel {
    
    func getDetailComments(commentID: Int) {
        commentsManager.getDetailComments(commentID: commentID)
            .subscribe(onSuccess: { response in
                print("response: \(response)")
                let commentsList = [CommentsSection(header: response.parentComment, items: response.childComments)]
                self.commentsList.accept(commentsList)
            }, onFailure: { error in
                if let moyaError = error as? MoyaError {
                    if let statusCode = moyaError.response?.statusCode {
                        let networkError = NetworkError(rawValue: statusCode)
                        switch networkError {
                        case .invalidRequest:
                            print("invalidRequest")
                        default:
                            print("network error")
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
