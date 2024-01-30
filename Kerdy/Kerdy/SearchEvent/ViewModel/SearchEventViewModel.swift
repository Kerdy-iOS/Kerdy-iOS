//
//  SearchEventViewModel.swift
//  Kerdy
//
//  Created by 이동현 on 12/22/23.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchEventViewModel {
    // MARK: - Property
    private let eventManager = EventManager.shared
    
    let isSearching: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let recentSearches: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    let eventsRelay: BehaviorRelay<[Event]> = BehaviorRelay(value: [])
    
    private let disposeBag = DisposeBag()
    private var filter = EventFilter()
    
    // MARK: - Initialize
    init() {
        loadRecentSearched()
        binding()
    }
    
    // MARK: - Binding
    private func binding() {
        recentSearches
            .subscribe { [weak self] _ in
                self?.saveRecentSearched()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Method
    private func loadRecentSearched() {
        if let recentSearches = UserDefaults.standard.value(forKey: "recentSearch") as? [String] {
            self.recentSearches.accept(recentSearches)
        }
    }
    
    private func saveRecentSearched() {
        UserDefaults.standard.setValue(recentSearches.value, forKey: "recentSearch")
    }
    
    func addRecentSearch(keyword: String) {
        var updateSearches = recentSearches.value
        
        if let existingIndex = updateSearches.firstIndex(of: keyword) {
            updateSearches.remove(at: existingIndex)
        }
        
        if updateSearches.count >= 5 {
            updateSearches.removeLast()
        }
        
        updateSearches.insert(keyword, at: 0)
        recentSearches.accept(updateSearches)
    }
    
    func deleteRecentSearch(keyword: String) {
        var updateSearches = recentSearches.value
        
        if let existingIndex = updateSearches.firstIndex(of: keyword) {
            updateSearches.remove(at: existingIndex)
        }
        recentSearches.accept(updateSearches)
    }
    
    func removeRecentAll() {
        recentSearches.accept([])
    }
}

extension SearchEventViewModel {
    func getEvents(keyword: String) {
        filter.keyword = keyword
        eventManager.getEvents(category: nil, eventFilter: filter)
            .subscribe(onSuccess: { [weak self] events in
                self?.eventsRelay.accept(events)
            }, onFailure: { error in
                print("Error fetching events: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
