//
//  EventDetailViewModel.swift
//  Kerdy
//
//  Created by 이동현 on 1/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EventDetailViewModel {
    private let feedManager = FeedManager.shared
    private let eventManager = EventManager.shared
    private let scrapManager = ScrapManager.shared
    
    private let eventRelay = BehaviorRelay<EventResponseDTO?>(value: nil)
    private let feedRelay = BehaviorRelay<[FeedResponseDTO]>(value: [])
    private let recruitmentRelay = BehaviorRelay<[RecruitmentResponseDTO]>(value: [])
    private let scrapStateRelay = BehaviorRelay<Bool>(value: false)
    
    var event: Observable<EventResponseDTO?> {
        return eventRelay.asObservable()
    }
    
    var feeds: Observable<[FeedResponseDTO]> {
        return feedRelay.asObservable()
    }
    
    var recruitments: Observable<[RecruitmentResponseDTO]> {
        return recruitmentRelay.asObservable()
    }
    
    var scrapState: Observable<Bool> {
        return scrapStateRelay.asObservable()
    }
    
    private var disposeBag = DisposeBag()
    
    init() {
        setupBinding()
    }
    
    private func setupBinding() {
        event
            .compactMap { $0 }
            .flatMapLatest { [weak self] event in
                guard let self = self else { return Observable.just(()) }
                let feeds = self.feedManager.getAllFeed(eventID: event.id)
                let recruitments = self.eventManager.getRecruitments(eventId: event.id)
                return Observable.combineLatest(
                    feeds.asObservable(),
                    recruitments.asObservable()
                )
                .map { feeds, recruitments in
                    self.feedRelay.accept(feeds)
                    self.recruitmentRelay.accept(recruitments)
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func setEvent(_ event: EventResponseDTO) {
        eventRelay.accept(event)
    }
    
    func getEvent() -> EventResponseDTO? {
        return eventRelay.value
    }
    
    func getFeeds() -> [FeedResponseDTO] {
        return feedRelay.value
    }
    
    func getRecruitments() -> [RecruitmentResponseDTO] {
        return recruitmentRelay.value
    }
    
    func setScrapState(_ state: Bool) {
        scrapStateRelay.accept(state)
    }
    
    func scrapButtonTapped() {
        let curState = scrapStateRelay.value
        guard let event = eventRelay.value else { return }
        
        if !curState {
            scrapManager.addScrap(id: event.id)
                .subscribe { _ in
                    self.scrapStateRelay.accept(true)
                } onFailure: { error in
                    print(error.localizedDescription)
                }
                .disposed(by: disposeBag)
        } else {
            scrapManager.deleteScrap(id: event.id)
                .subscribe { _ in
                    self.scrapStateRelay.accept(false)
                } onFailure: { error in
                    print(error.localizedDescription)
                }
                .disposed(by: disposeBag)
        }
    }
}
