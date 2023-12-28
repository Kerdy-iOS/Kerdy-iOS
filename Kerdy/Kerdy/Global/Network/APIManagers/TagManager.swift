//
//  TagManager.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/8/23.
//

import UIKit

import Moya
import RxSwift

struct requestTags {
    
}

protocol TagManagerType {
    
    func getAllTags() -> Single<[TagsResponseDTO]>
    func getUserTags(id: Int) -> Single<[TagsResponseDTO]>
    func postTags(id: [Int]) -> Single<[TagsResponseDTO]>
    func deleteTags(id: [Int]) -> Single<[TagsResponseDTO]>
}

final class TagManager: Networking, TagManagerType {
    
    typealias API = TagAPI
    
    static let shared = TagManager()
    
    private let disposeBag = DisposeBag()
    
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private init () {}
    
    func getAllTags() -> Single<[TagsResponseDTO]> {
        return provider
            .request(.allTags)
            .map([TagsResponseDTO].self)
    }
    
    func getUserTags(id: Int) -> Single<[TagsResponseDTO]> {
        return provider
            .request(.getTags(memberID: id))
            .map([TagsResponseDTO].self)
    }
    
    func postTags(id: [Int]) -> Single<[TagsResponseDTO]> {
        return provider
            .request(.updateTags(id: id))
            .map([TagsResponseDTO].self)
    }
    
    func deleteTags(id: [Int]) -> Single<[TagsResponseDTO]> {
        return provider
            .request(.deleteTags(id: id))
            .map([TagsResponseDTO].self)
    }
}
