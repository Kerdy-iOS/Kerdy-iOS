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
            .map { notifications -> [ArchiveSectionModel] in
                
                let filteredNotifications = self.filterNotifications(notifications)
                
                let newNotifications = filteredNotifications.filter { !$0.isRead }
                let oldNotifications = filteredNotifications.filter { $0.isRead }
                
                let newSection = ArchiveSectionModel.new(items: newNotifications.map { .new($0) })
                let oldSection = ArchiveSectionModel.old(items: oldNotifications.map { .old($0) })
                
                return [newSection, oldSection]
            }
            .subscribe(onSuccess: { [weak self] list in
                guard let self = self else { return }
                self.archiveList.accept(list)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func patchNotification(id: Int) {
        notificationManager.patchList(id: id)
            .subscribe(onSuccess: { [weak self] data in
                dump(data)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteNotification(ids: [Int]) {
        notificationManager.deleteList(ids: ids)
            .subscribe(onSuccess: { [weak self] _ in
                guard let self else { return }
                guard let id = self.id else { return }
                self.getNotifications(id: id)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func updateList(index: IndexPath, action: ((Int) -> Void)? = nil) {
        let patchList = archiveList.value
        let patchData = patchList[index.section].items[index.item]
        switch patchData {
        case .new(let data), .old(let data):
            let notificationID = data.notificationID
            action?(notificationID)
        }
    }
    
    func deleteAllNotification(index: IndexPath) {
        let patchList = archiveList.value
        let sectionItems = patchList[index.section].items
        
        let notificationIDs = sectionItems.compactMap { item -> Int? in
            if case let .old(data) = item {
                return data.notificationID
            }
            return nil
        }
        self.deleteNotification(ids: notificationIDs)
    }
    
    func filterNotifications(_ notifications: [ArchiveResponseDTO]) -> [ArchiveResponseDTO] {
        guard UserDefaultStore.isNotification else { return [] }
        
        switch (UserDefaultStore.isCommentsSelected, UserDefaultStore.isTagSelected) {
        case (true, true):
            return notifications
        case (true, false):
            return notifications.filter { $0.type == .comment }
        case (false, true):
            return notifications.filter { $0.type == .event }
        default:
            return []
        }
    }
}
