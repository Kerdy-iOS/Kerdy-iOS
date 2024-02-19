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
    
    func getEvents(category: String?, eventFilter: EventFilter) -> Single<[EventResponseDTO]> {
        return provider.request(.getEvents(category: category, filter: eventFilter))
            .map([EventResponseDTO].self)
    }
    
    func getEvent(eventId: Int) -> Single<EventResponseDTO> {
        return provider.request(.getEvent(eventId: eventId))
            .map(EventResponseDTO.self)
    }
    
    func postRecruitment(eventId: Int, memberId: Int, content: String) -> Single<Void> {
        return provider.request(.postRecruitment(eventId: eventId, memberId: memberId, content: content))
            .map { _ in }
    }
    
    func updateRecruitment(eventId: Int, postId: Int, content: String) -> Single<Void> {
        return provider.request(.updateRecruitment(eventId: eventId, postId: postId, content: content))
            .map { _ in }
    }
    
    func deleteRecruitment(eventId: Int, postId: Int) -> Single<Void> {
        return provider.request(.deleteRecruitment(eventId: eventId, postId: postId))
            .map { _ in }
    }
    
    func getRecruitments(eventId: Int) -> Single<[RecruitmentResponseDTO]> {
        return provider.request(.getRecruitments(eventId: eventId))
            .map([RecruitmentResponseDTO].self)
    }
    
    func getRecruitment(eventId: Int, postId: Int) -> Single<RecruitmentResponseDTO> {
        return provider.request(.getRecruitment(eventId: eventId, postId: postId))
            .map(RecruitmentResponseDTO.self)
    }
    
    func getUserRecruitments(memberId: Int) -> Single<[RecruitmentResponseDTO]> {
        return provider.request(.getUserRecruitments(memberId: memberId))
            .map([RecruitmentResponseDTO].self)
    }
    
    func isAlreadyRecruited(eventId: Int, memberId: Int) -> Single<Bool> {
        return provider.request(.isAlreadyRecruited(eventId: eventId, memberId: memberId))
            .map { response in
                guard let stringValue = String(data: response.data, encoding: .utf8) else {
                    throw NSError(domain: "isAlreadyRecruitedString", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                }
                
                guard let isRecruited = Bool(stringValue.lowercased()) else {
                    throw NSError(domain: "isAlreadyRecruitedResult", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                }
                
                return isRecruited
            }
    }
}
