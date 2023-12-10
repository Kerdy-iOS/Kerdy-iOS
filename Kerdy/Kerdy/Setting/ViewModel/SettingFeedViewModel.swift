//
//  SettingFeedViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import Foundation

import RxCocoa
import RxSwift

import Moya

final class SettingFeedViewModel {
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    private let feedManager: FeedManager
    
    // MARK: - Init
    
    init(feedManager: FeedManager) {
        self.feedManager = feedManager
    }
    
    struct Input {
        let viewWillAppear: Driver<Bool>
    }
    
    struct Output {
        let feedList: Driver<[FeedResponseDTO]>
    }
    
    private let feedList = BehaviorRelay<[FeedResponseDTO]>(value: [])
    func transform(input: Input) -> Output {
        
        let output = Output(feedList: feedList.asDriver())
        
        input.viewWillAppear
            .drive(with: self) { owner, _ in
                owner.getUserFeed()
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

// MARK: - Methods

extension SettingFeedViewModel {
    
    func getUserFeed() {
        feedManager.getUserFeed()
            .subscribe(onSuccess: { response in
                dump(response)
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
