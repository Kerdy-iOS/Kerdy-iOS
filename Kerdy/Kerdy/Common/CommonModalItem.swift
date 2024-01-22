//
//  CommonModalItem.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/11/24.
//

import UIKit

import RxDataSources
import RxSwift
import RxCocoa
import RxRelay

struct CommonModalItem: Equatable {
    
    let type: AlertType
    var titleColor: UIColor? = .kerdyBlack
    
    init(type: AlertType, titleColor: UIColor? = .kerdyBlack) {
        self.type = type
        self.titleColor = titleColor
    }
    
    static let reportModal: [CommonModalItem]  = [CommonModalItem(type: .report, titleColor: .kerdyRed)]
    static let basicModal: [CommonModalItem] = [CommonModalItem(type: .modify), 
                                                CommonModalItem(type: .delete)]
}

struct CommonModalSectionItem {
    typealias Model = SectionModel<Section, Item>
    
    enum Section: Int, Equatable {
        case main
    }
    
    enum Item: Equatable {
        case report(CommonModalItem)
        case basic(CommonModalItem)
    }
}

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
    }
    
    private let modalList = BehaviorRelay<[CommonModalSectionItem.Model]>(value: [])
    let deleteComment = BehaviorRelay<Int>(value: 0)
    private let height = BehaviorRelay<Int>(value: 0)
    private let reportResult = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        let output = Output(modalList: modalList.asDriver(),
                            modalHeight: height.asDriver(),
                            reportResult: reportResult.asSignal())
        
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
            .subscribe(onSuccess: { data in
                dump(data)
                self.deleteComment.accept(commentID)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func postReport(request: ReportRequestDTO) {
        reportManager.postReport(request: request)
            .subscribe(onSuccess: { data in
                dump(data)
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
