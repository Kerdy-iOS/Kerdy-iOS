//
//  ScrpaManager.swift
//  Kerdy
//
//  Created by 이동현 on 12/24/23.
//

import Foundation
import Moya
import RxSwift

final class ScrapManager {
    typealias API = ScrapAPI
    static let shared = ScrapManager()
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private init() {}
    
    func getScraps() -> Single<[EventResponseDTO]> {
        return provider.request(.getScraps)
            .map([EventResponseDTO].self)
    }
    
    func addScrap(id: Int) -> Single<EventResponseDTO> {
        return provider.request(.addScrap(id: id))
            .map(EventResponseDTO.self)
    }
    
    func deleteScrap(id: Int) -> Single<EventResponseDTO> {
        return provider.request(.deleteScrap(id: id))
            .map(EventResponseDTO.self)
    }

}
