//
//  SettingCommenetViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import Foundation

import RxCocoa
import RxSwift

import Moya

final class SettingCommenetViewModel {
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    private let commentManager: CommentManager
    private let id = Int(KeyChainManager.read(forkey: .memberId) ?? "" )
    
    // MARK: - Init
    
    init(commentManager: CommentManager) {
        self.commentManager = commentManager
    }
    
    struct Input {
        let viewWillAppear: Driver<Bool>
    }
    
    struct Output {
        let commentsList: Driver<[CommentsResponseDTO]>
    }
    
    private let commentsList = BehaviorRelay<[CommentsResponseDTO]>(value: [])
    func transform(input: Input) -> Output {
        
        let output = Output(commentsList: commentsList.asDriver())
        
        input.viewWillAppear
            .drive(with: self) { owner, _ in
                guard let id = self.id else { return }
                owner.getUserComments(id: id)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

// MARK: - Methods

extension SettingCommenetViewModel {
    
    func getUserComments(id: Int) {
        //        commentManager.getUserCommnets(id: id)
        commentManager.getUserCommnets(id: 24)
            .subscribe(onSuccess: { response in
                self.commentsList.accept(response)
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
