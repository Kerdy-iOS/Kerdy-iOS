//
//  EventViewModel.swift
//  Kerdy
//
//  Created by 이동현 on 12/14/23.
//

import Foundation

import RxCocoa
import RxSwift

final class EventViewModel {
    private let eventManager = EventManager.shared
    private let disposeBag = DisposeBag()
    private let filterRelay = BehaviorRelay<EventFilter>(value: EventFilter())
    
    private var filterObservable: Observable<EventFilter> {
        return filterRelay.asObservable().distinctUntilChanged()
    }
    
    private let scrapEvents: BehaviorRelay<[Event]> = BehaviorRelay(value: [])
    private let conferenceEvents: BehaviorRelay<[Event]> = BehaviorRelay(value: [])
    private let competitionEvents: BehaviorRelay<[Event]> = BehaviorRelay(value: [])

    var combinedEvents: Observable<[[Event]]> {
        return Observable.zip(scrapEvents, conferenceEvents, competitionEvents) {
            [$0, $1, $2]
        }
    }
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        filterObservable
            .flatMapLatest { [weak self] filter -> Observable<Void> in
                guard let self = self else { return Observable.just(()) }
                
                return Observable.combineLatest(
                    self.eventManager.getEvents(category: nil, eventFilter: filter),
                    self.eventManager.getEvents(category: "CONFERENCE", eventFilter: filter),
                    self.eventManager.getEvents(category: "COMPETITION", eventFilter: filter)
                )
                .map { scrapEvents, conferenceEvents, competitionEvents in
                    self.scrapEvents.accept(scrapEvents)
                    self.conferenceEvents.accept(conferenceEvents)
                    self.competitionEvents.accept(competitionEvents)
                }
                .catchAndReturn(())
            }
            .subscribe()
            .disposed(by: disposeBag)
    }

    func updateFilter(_ newFilter: EventFilter) {
        filterRelay.accept(newFilter)
    }
}
