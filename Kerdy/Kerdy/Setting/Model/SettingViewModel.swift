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

import Moya

final class SettingViewModel: ViewModelType {
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    private let settingManager: SettingManager
    private let id = Int(KeyChainManager.read(forkey: .memberId) ?? "0") 
    private let profileList = BehaviorRelay<MemberProfileResponseDTO>(value: .empty())
    
    // MARK: - Init
    
    init(settingManager: SettingManager) {
        self.settingManager = settingManager
    }

    struct Input {
        let viewWillAppear: Driver<Bool>
    }
    
//    struct CellInput {
//        let tapArticleButton: Signal<Void>
//        let tapCommentsButton: Signal<Void>
//    }
    
    struct Output {
        let settingList: BehaviorRelay<MemberProfileResponseDTO>
    }
//    
//    struct CellOutput {
//        let didArticleButtonTapped: Signal<Void>
//        let didCommentsButtonTapped: Signal<Void>
//    }
    
    func transform(input: Input) -> Output {
        
        let output = Output(settingList: profileList)
        
        input.viewWillAppear
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                guard let id = self.id else { return }
                owner.getMember(id: id)
            })
            .disposed(by: disposeBag)

        return output
    }
//    
//    func transform(input: CellInput) -> CellOutput {
//        let didArticleButtonTapped = PublishRelay<Void>()
//        let didCommentsButtonTapped = PublishRelay<Void>()
//        
//        let output = CellOutput(didArticleButtonTapped: didArticleButtonTapped.asSignal(),
//                                didCommentsButtonTapped: didCommentsButtonTapped.asSignal())
//        
//        input.tapArticleButton
//            .asObservable()
//        .take(1)
//        .bind(to: didCommentsButtonTapped)
//            .disposed(by: disposeBag)
//        
//        input.tapCommentsButton
//            .asObservable()
//            .take(1)
//            .bind(to: didCommentsButtonTapped)
//            .disposed(by: disposeBag)
//        
//        return output
//    }
}

extension SettingViewModel {
    
    func getMember(id: Int) {
        settingManager.getMemger(id: id)
            .subscribe(onSuccess: { response in
               self.profileList.accept(response)
            }, onFailure: { error in
                if let moyaError = error as? MoyaError {
                    if let statusCode = moyaError.response?.statusCode {
                        let networkError = NetworkError(rawValue: statusCode)
                        switch networkError {
                        case .invalidRequest:
                            print("invalidRequest")
                        default:
                            print("network error")
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
}
