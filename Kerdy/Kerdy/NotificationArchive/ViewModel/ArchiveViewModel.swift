//
//  ArchiveViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/22/24.
//

import Foundation

import RxSwift
import RxRelay
import RxCocoa

import Moya

final class ArchiveViewModel: ViewModelType {
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    
    private let notificationManager = NotificationManager.shared
    private let id = Int(KeyChainManager.loadMemberID())
    
    struct Input {
        let viewWillAppear: Driver<Bool>
    }
    
    struct Output {
        let archiveList: Driver<[ArchiveSectionModel]>
    }
    
    private let archiveList = BehaviorRelay<[ArchiveSectionModel]>(value: [])
    
    func transform(input: Input) -> Output {
        
        let output = Output(archiveList: archiveList.asDriver())
        
        input.viewWillAppear
            .asDriver()
            .drive(with: self) { owner, _ in
                guard let id = self.id else { return }
                owner.getNotifications(id: id)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

extension ArchiveViewModel {
    
    func getNotifications(id: Int) {
        notificationManager.getList(id: id)
            .map { notifications in
                return notifications.map { notification in
                    let sectionItem: ArchiveSectionModel = notification.isRead
                    ? .old(items: [.old(notification)])
                    : .new(items: [.new(notification)])
                    return sectionItem
                }
            }
            .subscribe(onSuccess: { [weak self] list in
                guard let self = self else { return }
                self.archiveList.accept(list)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
}
