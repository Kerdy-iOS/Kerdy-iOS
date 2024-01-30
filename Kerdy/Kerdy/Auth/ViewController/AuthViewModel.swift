//
//  AuthViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/26/23.

import Foundation

import RxCocoa
import RxSwift

import Moya

final class AuthViewModel {
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    private let loginManager = LoginManager.shared
    
    private let token = KeyChainManager.loadDeviceToken()

    struct Input {
        let authButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let didLoginTapped: Signal<Void>
    }
    
    private let didLoginTapped = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        
        let output = Output(didLoginTapped: didLoginTapped.asSignal())
        
        input.authButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.handleAuthorization()
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

// MARK: - Methods

extension AuthViewModel {
    
    func handleAuthorization() {
        getAuthorizationCode { [weak self] code in
            guard let self else { return }
            self.postSignInAPI(code: code)
        }
    }
    
    private func getAuthorizationCode(callback: @escaping (String) -> Void) {
        loginManager.getAuthorizationCode { code in
            callback(code)
        }
    }
    
    func postSignInAPI(code: String) {
        loginManager.postLogin(code: code)
            .subscribe(onSuccess: { response in
                KeyChainManager.save(forKey: .accessToken, value: response.accessToken)
                KeyChainManager.save(forKey: .memberId, value: "\(response.id)")
                self.didLoginTapped.accept(())
                let request = AuthRequestDTO(token: self.token, memberId: response.id)
                self.postFCM(request: request)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func postFCM(request: AuthRequestDTO) {
        loginManager.postFCM(request: request)
            .subscribe(onSuccess: { response in
                dump(response)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
}
