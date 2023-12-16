//
//  AuthInterceptor.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/27/23.
//

import Foundation

import Alamofire
import RxSwift

final class AuthInterceptor: RequestInterceptor {
    
    private let disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = KeyChainManager.read(forkey: .accessToken)
        else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(bearerToken: accessToken))
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 400
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // TODO: - accessToken 만료 로직 구현
    }
}
