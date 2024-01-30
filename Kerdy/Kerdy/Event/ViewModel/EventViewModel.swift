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
    private let scrapManager = ScrapManager.shared
    private let disposeBag = DisposeBag()
    private let filterRelay = BehaviorRelay<EventFilter>(value: EventFilter())
    private let curEventRelay = BehaviorRelay<[EventResponseDTO]>(value: [])
    private var eventCVIndex: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    private let scrapEvents: BehaviorRelay<[EventResponseDTO]> = BehaviorRelay(value: [])
    private let conferenceEvents: BehaviorRelay<[EventResponseDTO]> = BehaviorRelay(value: [])
    private let competitionEvents: BehaviorRelay<[EventResponseDTO]> = BehaviorRelay(value: [])

    var filterObservable: Observable<EventFilter> {
        return filterRelay.asObservable().distinctUntilChanged()
    }
    
    var curEventObservable: Observable<[EventResponseDTO]> {
        return curEventRelay.asObservable()
    }
    
    private var indexObservable: Observable<Int> {
        return eventCVIndex.asObservable()
    }
    
    var combinedEvents: Observable<[[EventResponseDTO]]> {
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
                    self.scrapManager.getScraps().asObservable(),
                    self.eventManager.getEvents(category: "CONFERENCE", eventFilter: filter).asObservable(),
                    self.eventManager.getEvents(category: "COMPETITION", eventFilter: filter).asObservable()
                )
                .map { scrapEvents, conferenceEvents, competitionEvents in
                    self.scrapEvents.accept(scrapEvents)
                    self.conferenceEvents.accept(conferenceEvents)
                    self.competitionEvents.accept(competitionEvents)
                    
                    let eventsArray = [scrapEvents, conferenceEvents, competitionEvents]
                    self.curEventRelay.accept(eventsArray[self.eventCVIndex.value])
                }
                .catchAndReturn(())
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        indexObservable
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                let eventsArray = [self.scrapEvents.value, self.conferenceEvents.value, self.competitionEvents.value]
                self.curEventRelay.accept(eventsArray[index])
            })
            .disposed(by: disposeBag)
    }

    func updateFilter(_ newFilter: EventFilter) {
        filterRelay.accept(newFilter)
    }
    
    func getCurrentFilter() -> EventFilter {
        return filterRelay.value
    }
    
    func deleteFilter(type: FilterType, name: String) {
        var currentFilter = filterRelay.value
        
        switch type {
        case .progress:
            if let progress = EventProgress.allCases.first(where: { $0.value == name}) {
                currentFilter.statuses = currentFilter.statuses?.filter { $0 != progress.value }
            }
        case .tag:
            currentFilter.tags = currentFilter.tags?.filter { $0 != name }
        case .date:
            currentFilter.startDate = nil
            currentFilter.endDate = nil
        }
        
        filterRelay.accept(currentFilter)
    }
    
    func setEventCVIndex(index: Int) {
        eventCVIndex.accept(index)
    }
}
