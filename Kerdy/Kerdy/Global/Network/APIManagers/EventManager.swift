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
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private init() {}
    
    func getEvents(category: String?, eventFilter: EventFilter) -> Single<[Event]> {
        return provider.request(.getEvents(category: category, filter: eventFilter))
            .map([Event].self)
    }
}
