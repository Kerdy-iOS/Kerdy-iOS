//
//  EventManager.swift
//  Kerdy
//
//  Created by 이동현 on 12/15/23.
//

import Foundation
import Moya
import RxSwift

final class EventManager {
    typealias API = EventAPI
    static let shared = EventManager()
    private let provider = MoyaProvider<API>()
    
    private init() {}
    
    func getEvents(
            category: String?,
            startDate: Date?,
            endDate: Date?,
            statuses: [String]?,
            keyword: String?
    ) -> Observable<Data> {
        return Observable.create { observer in
            self.provider.request(.getEvents(
                category: category,
                startDate: startDate,
                endDate: endDate,
                statuses: statuses,
                keyword: keyword
            )) {
                switch $0 {
                case .success(let response):
                    observer.onNext(response.data)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
