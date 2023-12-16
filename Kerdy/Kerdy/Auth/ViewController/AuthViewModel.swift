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
    private let loginManager: LoginManager
    
    private let didLoginTapped = PublishRelay<Void>()
    
    // MARK: - Init
    
    init(loginManager: LoginManager) {
        self.loginManager = loginManager
    }
    
    struct Input {
        let authButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let didLoginTapped: Signal<Void>
    }
    
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
