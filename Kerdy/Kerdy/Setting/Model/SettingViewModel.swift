//
//  SettingViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/11/23.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

final class SettingViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
    }
    
    struct CellInput {
        let tapProfileButton: Signal<Void>
        let tapArticleButton: Signal<Void>
        let tapCommentsButton: Signal<Void>
    }
    
    struct Output {
        let settingList: BehaviorRelay<[ProfileResponseDTO]>
    }
    
    struct CellOutput {
        let didProfileButtonTapped: Signal<Void>
        let didArticleButtonTapped: Signal<Void>
        let didCommentsButtonTapped: Signal<Void>
    }
    
    func transform(input: Input) -> Output {
        let profileList = BehaviorRelay(value: [ProfileResponseDTO.dummy()])
        
        let output = Output(settingList: profileList)
        
        input.viewWillAppear
            .withLatestFrom(profileList)
            .subscribe(with: self, onNext: { _, updatedProfileList in
                output.settingList.accept(updatedProfileList)
            })
            .disposed(by: disposeBag)
        return output
    }
    
    func transform(input: CellInput) -> CellOutput {
        let didProfileButtonTapped = PublishRelay<Void>()
        let didArticleButtonTapped = PublishRelay<Void>()
        let didCommentsButtonTapped = PublishRelay<Void>()
        
        let output = CellOutput(didProfileButtonTapped: didProfileButtonTapped.asSignal(),
                                didArticleButtonTapped: didArticleButtonTapped.asSignal(),
                                didCommentsButtonTapped: didCommentsButtonTapped.asSignal())
        
        input.tapProfileButton
            .emit()
            .disposed(by: disposeBag)
        
        input.tapArticleButton
            .emit()
            .disposed(by: disposeBag)
        
        input.tapCommentsButton
            .emit()
            .disposed(by: disposeBag)
        
        return output
    }
}
