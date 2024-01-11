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

enum ModalType: String {
    case report, modify, delete
    
    var title: String {
        switch self {
        case .report: return "신고하기"
        case .modify: return "수정"
        case .delete: return "삭제"
        }
    }
}

struct CommonModalItem: Equatable {
    
    let type: ModalType
    var titleColor: UIColor? = .kerdyBlack
    
    static let reportModal: [CommonModalItem]  = [CommonModalItem(type: .report, titleColor: .kerdyRed)]
    static let basicModal: [CommonModalItem] = [CommonModalItem(type: .modify), CommonModalItem(type: .delete)]
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
    
    var commentsManager = CommentManager.shared
    var reportManager = ReportManager.shared
    var disposeBag =  DisposeBag()
    let userID = Int(KeyChainManager.loadMemberID())
    var memberID: Int? = 0
    var commentID: Int? = 0
    
    // MARK: - init
    
    init(memberID: Int, commentID: Int) {
        self.memberID = memberID
        self.commentID = commentID
    }
    
    struct Input {
        
        let viewWillAppear: Driver<Bool>
    }
    
    struct Output {
        
        let modalList: Driver<[CommonModalSectionItem.Model]>
    }
    
    private let modalList = BehaviorRelay<[CommonModalSectionItem.Model]>(value: [])
    
    func transform(input: Input) -> Output {
        let output = Output(modalList: modalList.asDriver())
        
        input.viewWillAppear
            .flatMap { _ -> Driver<Int> in
                guard let memberID = self.memberID else { return Driver.just(0) }
                return Driver.just(memberID)
            }
            .drive(with: self) { owner, memberID in
                print("🐻‍❄️🐻‍❄️🐻‍❄️🐻‍❄️🐻‍❄️ memberID : \(memberID)")
                print("🔴🔴🔴🔴🔴🔴 userID :\(self.userID)")
                let items: [CommonModalSectionItem.Item] = (memberID == self.userID) ?
                CommonModalItem.basicModal.map { CommonModalSectionItem.Item.basic($0) } :
                CommonModalItem.reportModal.map { CommonModalSectionItem.Item.report($0) }
                let sectionModel = CommonModalSectionItem.Model(model: .main, items: items)
                owner.modalList.accept([sectionModel])
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
}

extension CommonModalViewModel {
    
    func deleteComments() {
        guard let commentsID = self.commentID else { return }
        commentsManager.deleteComments(commentID: commentsID)
            .subscribe(onSuccess: { data in
                dump(data)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func postReport(request: ReportRequestDTO) {
        reportManager.postReport(request: request)
            .subscribe(onSuccess: { data in
                dump(data)
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
            guard let reportedID = self.memberID else { return }
            guard let commentID = self.commentID else { return }
            let request = ReportRequestDTO(reporterId: reporterId,
                                           reportedId: reportedID,
                                           type: .COMMENT,
                                           contentId: commentID)
            self.postReport(request: request)
        }
    }
}
