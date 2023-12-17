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
    private let id = Int(KeyChainManager.loadMemberID())
    private let basicItems = SettingBasicModel.basicWithIcon + SettingBasicModel.basic
    private let settingList = BehaviorRelay<([SettingSectionItem.Model])>(value: [])
    
    // MARK: - Init
    
    init(settingManager: SettingManager) {
        self.settingManager = settingManager
    }
    
    struct Input {
        
        let viewWillAppear: Driver<Bool>
    }
    
    struct Output {
        
        let settingList: Driver<[SettingSectionItem.Model]>
    }
    
    func transform(input: Input) -> Output {
        
        let output = Output(settingList: settingList.asDriver())
        
        input.viewWillAppear
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self, onNext: { owner, _ in
                guard let id = self.id else { return }
                owner.getMember(id: id)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SettingViewModel {
    
    func getMember(id: Int) {
        settingManager.getMember(id: id)
            .subscribe(onSuccess: { response in
                
                let profile = SettingSectionItem.Item.profile(response)
                let basic = self.basicItems.map { SettingSectionItem.Item.basic($0)}
                let profileSection = SettingSectionItem.Model(model: .profile, items: [profile])
                let basicSection = SettingSectionItem.Model(model: .basic, items: basic)
                
                self.settingList.accept([profileSection, basicSection])
                
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
    
    func withdrawalMember() {
        guard let id = self.id else { return }
        settingManager.deleteMember(id: id)
            .subscribe(onSuccess: { response in
                dump(response)
                KeyChainManager.removeAllKeychain()
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
    
    func logoutMember() {
        KeyChainManager.delete(forKey: .accessToken)
    }
    
    func authMember(type: AuthType) {
        if type == .logout {
            self.logoutMember()
        } else {
            self.withdrawalMember()
        }
    }
}
