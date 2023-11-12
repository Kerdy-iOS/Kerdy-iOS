//
//  SettingViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/11/23.
//

import Foundation

import RxSwift
import RxRelay

final class SettingViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    var profileList = BehaviorRelay(value: [ProfileResponseDTO.dummy()])
    struct Input {
        let viewWillAppear: Observable<Bool>
    }
    
    struct Output {
        let settingList =  BehaviorRelay<[ProfileResponseDTO]>(value: [])
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        input.viewWillAppear
            .flatMapLatest { [weak self] _ -> BehaviorRelay<[ProfileResponseDTO]> in
                guard let self else { return BehaviorRelay(value: [])}
                return profileList
            }
            .subscribe(with: self, onNext: { owner, profileList in
                output.settingList.accept(profileList)
            })
            .disposed(by: disposeBag)
        
        return output
        
    }
    
}
