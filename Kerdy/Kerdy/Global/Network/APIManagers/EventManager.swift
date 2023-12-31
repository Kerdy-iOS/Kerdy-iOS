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
    
    func getEvents(category: String?, eventFilter: EventFilter) -> Observable<[Event]> {
        return provider.rx.request(.getEvents(category: category, filter: eventFilter))
            .map { response in
                return try parseEvents(data: response.data)
            }
            .asObservable()
    }
}
