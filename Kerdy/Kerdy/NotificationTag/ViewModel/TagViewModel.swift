//
//  TagViewModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/8/23.
//

import Foundation

import RxSwift
import RxRelay
import RxCocoa

import Moya

final class TagViewModel: ViewModelType {
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    private let tagManager: TagManager
    
    // MARK: - Init
    
    init(tagManager: TagManager) {
        self.tagManager = tagManager
    }
    
    struct Input {
        
        let viewWillAppear: Driver<Bool>
        let tapRegisterButton: Signal<Void>
    }
    
    struct Output {
        
        let tagList: Driver<[TagSection]>
    }
    
    private let tagList = BehaviorRelay<[TagSection]>(value: [])
    private let requestTagList = BehaviorRelay<[Int]>(value: [])
    
    func transform(input: Input) -> Output {
        let output = Output(tagList: tagList.asDriver())
        
        input.viewWillAppear
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self, onNext: { owner, _ in
                owner.getTags()
            })
            .disposed(by: disposeBag)
        
        input.tapRegisterButton
            .withLatestFrom(requestTagList.asDriver())
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self, onNext: { owner, id in
                owner.postTags(id: id)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension TagViewModel {
    
    func getTags() {
        tagManager.getAllTags()
            .subscribe(onSuccess: { response in
                let tagList = [TagSection(items: response)]
                self.tagList.accept(tagList)
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
    
    func postTags(id: [Int]) {
        tagManager.postTags(id: id)
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
    
    func selectTags(id: [Int]) {
        self.requestTagList.accept(id)
    }
}
