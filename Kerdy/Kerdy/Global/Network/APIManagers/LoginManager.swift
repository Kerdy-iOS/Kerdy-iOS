//
//  LoginManager.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/26/23.
//

import UIKit

import Moya
import RxSwift

protocol LoginManagerType {
    
    func postLogin(code: String) -> Single<SignInResponseDTO>
    func postFCM(request: AuthRequestDTO) -> Single<Void>
    func getAuthorizationCode(callback: @escaping (String) -> Void)
    func handleAuthorizationCode(_ code: String)
}

final class LoginManager: Networking, LoginManagerType {
    
    typealias API = LoginAPI
    
    static let shared = LoginManager()
    
    private let disposeBag = DisposeBag()
    
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private var authorizationCodeCallback: ((String) -> Void)?
    
    private init() {}
    
    func postLogin(code: String) -> Single<SignInResponseDTO> {
        return provider
            .request(.signIn(code: code))
            .map(SignInResponseDTO.self)
    }
    
    func postFCM(request: AuthRequestDTO) -> Single<Void> {
        return provider
            .request(.fcm(request: request))
            .map {_ in}
    }
    
    func getAuthorizationCode(callback: @escaping (String) -> Void) {
            authorizationCodeCallback = callback

            let urlString = "https://github.com/login/oauth/authorize?client_id=\(BaseInfoManager.clientID)"
            if let url = URL(string: urlString), 
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }

        func handleAuthorizationCode(_ code: String) {
            authorizationCodeCallback?(code)
            authorizationCodeCallback = nil
        }
}
