//
//  FeedManager.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import Foundation

import RxSwift

protocol FeedManagerType {

    func getUserFeed() -> Single<[FeedResponseDTO]>
    func getAllFeed(eventID: Int) -> Single<[FeedResponseDTO]>
}

final class FeedManager: Networking, FeedManagerType {
    
    typealias API = FeedAPI
    
    static let shared = FeedManager()
    
    private let disposeBag = DisposeBag()
    
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private var authorizationCodeCallback: ((String) -> Void)?
    
    private init() {}
    
    func getUserFeed() -> Single<[FeedResponseDTO]> {
        return provider
            .request(.getUserFeed)
            .map([FeedResponseDTO].self)
    }
    
    func getAllFeed(eventID: Int) -> Single<[FeedResponseDTO]> {
        return provider
            .request(.getFeeds(eventID: eventID))
            .map([FeedResponseDTO].self)

    }
}
