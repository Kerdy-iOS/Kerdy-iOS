//
//  CommonModalViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/11/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxRelay

final class CommonModalViewModel: ViewModelType {
    
    // MARK: - Property
    
    private let commentsManager = CommentManager.shared
    private let reportManager = ReportManager.shared
    var disposeBag =  DisposeBag()
    private let userID = Int(KeyChainManager.loadMemberID())
    private let comments: [Comment]
    
    // MARK: - init
    
    init(comments: [Comment]) {
        self.comments = comments
    }
    
    struct Input {
        
        let viewWillAppear: Driver<Bool>
    }
    
    struct Output {
        
        let modalList: Driver<[CommonModalSectionItem.Model]>
        let modalHeight: Driver<Int>
        let reportResult: Signal<Void>
        let deleteCommentID: Signal<Void>
    }
    
    private let modalList = BehaviorRelay<[CommonModalSectionItem.Model]>(value: [])
    private let deleteComment = PublishRelay<Void>()
    private let height = BehaviorRelay<Int>(value: 0)
    private let reportResult = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        let output = Output(modalList: modalList.asDriver(),
                            modalHeight: height.asDriver(),
                            reportResult: reportResult.asSignal(),
                            deleteCommentID: deleteComment.asSignal())
        
        input.viewWillAppear
            .flatMap { _ -> Driver<Int> in
                let memberID = self.comments[0].memberID
                return Driver.just(memberID)
            }
            .drive(with: self) { owner, memberID in
                let items: [CommonModalSectionItem.Item] = (memberID == self.userID) ?
                CommonModalItem.basicModal.map { CommonModalSectionItem.Item.basic($0) } :
                CommonModalItem.reportModal.map { CommonModalSectionItem.Item.report($0) }
                
                let sectionModel = CommonModalSectionItem.Model(model: .main, items: items)
                
                owner.modalList.accept([sectionModel])
                owner.height.accept(sectionModel.items.count)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

extension CommonModalViewModel {
    
    func deleteComments() {
       
        guard let commentID = self.comments.first?.commentID else { return }
        commentsManager.deleteComments(commentID: commentID)
            .subscribe(onSuccess: { _ in
                self.deleteComment.accept(())
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func postReport(request: ReportRequestDTO) {
        reportManager.postReport(request: request)
            .subscribe(onSuccess: { _ in
                self.reportResult.accept(())
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func modalType(type: AlertType) {
        if type == .delete {
            self.deleteComments()
        } else if type == .report {
            guard let reporterId = self.userID else { return }
            guard let reportedID = self.comments.first?.memberID else { return }
            guard let commentID = self.comments.first?.commentID else { return }
            let request = ReportRequestDTO(reporterId: reporterId,
                                           reportedId: reportedID,
                                           type: .COMMENT,
                                           contentId: commentID)
            self.postReport(request: request)
        }
    }
}
