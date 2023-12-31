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
        eventFilter: EventFilter
    ) -> Observable<[Event]> {
        return Observable.create { observer in
            self.provider.request(.getEvents(category: category, filter: eventFilter)) {
                switch $0 {
                case .success(let response):
                    do {
                        let events = try parseEvents(data: response.data)
                        observer.onNext(events)
                        observer.onCompleted()
                    } catch {
                        print("Error parsing JSON:", error.localizedDescription)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
