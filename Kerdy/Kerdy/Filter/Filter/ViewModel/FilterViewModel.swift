//
//  FilterVM.swift
//  Kerdy
//
//  Created by 이동현 on 12/17/23.
//

import Foundation
import RxSwift
import RxCocoa

enum EventProgress: String, CaseIterable {
    case UPCOMING
    case IN_PROGRESS
    case ENDED
    
    var value: String {
        switch self {
        case .UPCOMING:
            return "진행예정"
        case .IN_PROGRESS:
            return "진행중"
        case .ENDED:
            return "마감"
        }
    }
}

final class FilterViewModel {
    
    private let disposeBag = DisposeBag()
    private let tagManager = TagManager.shared
    private var filter = EventFilter()
    
    let selectedProgress = BehaviorRelay<[String]>(value: [])
    let selectedTechs = BehaviorRelay<[String]>(value: [])
    let progressSectionData = BehaviorRelay<[String]>(value: ["진행중", "진행예정", "마감"])
    let techSectionData = BehaviorRelay<[String]>(value: [])
    let startDate = BehaviorRelay<String?>(value: nil)
    let endDate = BehaviorRelay<String?>(value: nil)
    
    
    init() {
        tagManager.getAllTags()
            .subscribe { [weak self] tags in
                let tagNames = tags.map{ $0.name }
                self?.techSectionData.accept(tagNames)
            }
            .disposed(by: disposeBag)
    }
    
    func setDate(startDate: String?, endDate: String?) {
        self.startDate.accept(startDate)
        self.endDate.accept(endDate)
    }
    
    func setFilter(_ filter: EventFilter) {
        self.filter = filter
        selectedProgress.accept(filter.statuses ?? [])
        selectedTechs.accept(filter.tags ?? [])
        startDate.accept(filter.startDate)
        endDate.accept(filter.endDate)
    }
    
    func applyFilter() -> EventFilter {
        filter.statuses = selectedProgress.value.isEmpty ? nil : selectedProgress.value
        filter.tags = selectedTechs.value.isEmpty ? nil : selectedTechs.value
        filter.startDate = startDate.value
        filter.endDate = endDate.value
        return filter
    }
    
    func resetFilter() {
        selectedProgress.accept([])
        selectedTechs.accept([])
        startDate.accept(nil)
        endDate.accept(nil)
    }
    
    func toggleSelectedProgress(tag: String) -> Bool {
        var updatedProgress = selectedProgress.value

        if updatedProgress.contains(tag) {
            updatedProgress.removeAll { $0 == tag }
        } else {
            updatedProgress.append(tag)
        }

        selectedProgress.accept(updatedProgress)
        return selectedProgress.value.contains(tag)
    }

    func toggleSelectedTag(tag: String) -> Bool {
        var updatedTags = selectedTechs.value

        if updatedTags.contains(tag) {
            updatedTags.removeAll { $0 == tag }
        } else {
            updatedTags.append(tag)
        }

        selectedTechs.accept(updatedTags)
        return selectedTechs.value.contains(tag)
    }
}
