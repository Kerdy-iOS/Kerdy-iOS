//
//  ProfileViewModel.swift
//  Kerdy
//
//  Created by 최다경 on 12/24/23.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel {
    
    var dummy: [String] = ["Java", "SpringBoot", "AWS", "MySQL", "Javascrip", "Github", "Spring", "Python", "데이터분석", "Git", "Docker", "커뮤니케이션", "typescript", "React"]
    
    let selectedTechs = BehaviorRelay<[String]>(value: [])
    
    let techSectionData = BehaviorRelay<[String]>(value: [])
    
    let selectedActivity = BehaviorRelay<[String]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    init() {
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
