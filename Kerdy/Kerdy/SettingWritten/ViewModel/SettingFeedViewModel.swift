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
        //        feedManager.getUserFeed()
        feedManager.getAllFeed(eventID: 6)
            .subscribe(onSuccess: { response in
                self.feedList.accept(response)
            }, onFailure: { error in
                HandleNetworkError.handleNetworkError(error)
            })
            .disposed(by: disposeBag)
    }
}
