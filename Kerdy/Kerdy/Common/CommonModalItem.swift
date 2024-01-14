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
    var index: IndexPath? = IndexPath(item: 0, section: 0)
    
    init(type: AlertType, titleColor: UIColor? = .kerdyBlack, index: IndexPath? = IndexPath(item: 0, section: 0)) {
        self.type = type
        self.titleColor = titleColor
        self.index = index
    }
    
    static let reportModal: [CommonModalItem]  = [CommonModalItem(type: .report, titleColor: .kerdyRed)]
    
    static func basicModal(with index: IndexPath) -> [CommonModalItem] {
        return [CommonModalItem(type: .modify, index: index),
                CommonModalItem(type: .delete)]
    }
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
    let userID = Int(KeyChainManager.loadMemberID())
    let comments: [Comment]
    let index: IndexPath
    
    // MARK: - init
    
    init(comments: [Comment], index: IndexPath) {
        self.comments = comments
        self.index = index
    }
    
    struct Input {
        
        let viewWillAppear: Driver<Bool>
    }
    
    struct Output {
        
        let modalList: Driver<[CommonModalSectionItem.Model]>
        let modalHeight: Driver<Int>
    }
    
    private let modalList = BehaviorRelay<[CommonModalSectionItem.Model]>(value: [])
    private let height = BehaviorRelay<Int>(value: 0)
    
    func transform(input: Input) -> Output {
        let output = Output(modalList: modalList.asDriver(), modalHeight: height.asDriver())
        
        input.viewWillAppear
            .flatMap { _ -> Driver<Int> in
                let memberID = self.comments[self.index.item].memberID
                return Driver.just(memberID)
            }
            .drive(with: self) { owner, memberID in
                
                let items: [CommonModalSectionItem.Item] = (memberID == self.userID) ?
                CommonModalItem.basicModal(with: self.index).map { CommonModalSectionItem.Item.basic($0) } :
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
        guard let commentID = self.comments[self.index.item].commentID else { return }
        commentsManager.deleteComments(commentID: commentID)
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
            let reportedID = self.comments[self.index.item].memberID
            guard let commentID = self.comments[self.index.item].commentID else { return }
            let request = ReportRequestDTO(reporterId: reporterId,
                                           reportedId: reportedID,
                                           type: .COMMENT,
                                           contentId: commentID)
            self.postReport(request: request)
        }
    }
}
