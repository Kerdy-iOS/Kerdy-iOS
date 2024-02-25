//
//  NotificationManager.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/11/24.
//

import Foundation

import Moya
import RxSwift

protocol NotificationManagerType {
    
    func getList(id: Int) -> Single<[ArchiveResponseDTO]>
    func patchList(id: Int) -> Single<Void>
    func deleteList(ids: [Int]) -> Single<Void>
}

final class NotificationManager: Networking, NotificationManagerType {
    
    typealias API = NotificationAPI
    
    static let shared = NotificationManager()
    
    private let disposeBag = DisposeBag()
    
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private init () {}
    
    func getList(id: Int) -> Single<[ArchiveResponseDTO]> {
        return provider
            .request(.notificationList(id: id))
            .map([ArchiveResponseDTO].self)
    }
    
    func patchList(id: Int) -> Single<Void> {
        return provider
            .request(.readState(id: id))
            .map { _ in }
    }
    
    func deleteList(ids: [Int]) -> Single<Void> {
        return provider
            .request(.deleteNotification(ids: ids))
            .map { _ in }
    }
}
