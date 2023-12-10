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
    private let id = Int(KeyChainManager.loadMemberID())
    
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
        let selectedList: Driver<[Int]>
        let didRegisterButtonTap: Signal<Void>
    }
    
    private let tagList = BehaviorRelay<[TagSection]>(value: [])
    private let selectedTagList = BehaviorRelay<[Int]>(value: [])
    private let didRegisterButtonTap = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        let output = Output(tagList: tagList.asDriver(),
                            selectedList: selectedTagList.asDriver(),
                            didRegisterButtonTap: didRegisterButtonTap.asSignal())
        
        input.viewWillAppear
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { [weak self] owner, _ in
                guard let self = self, let id = self.id else { return }
                owner.getAllTags()
                owner.getUserTags(id: id)
            }
            .disposed(by: disposeBag)
        
        input.tapRegisterButton
            .throttle(.seconds(1), latest: false)
            .withLatestFrom(selectedTagList.asDriver())
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self, onNext: { owner, id in
                owner.postTags(id: id)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension TagViewModel {
    
    func getAllTags() {
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
    
    func getUserTags(id: Int) {
        tagManager.getUserTags(id: id)
            .subscribe(onSuccess: { response in
                let idList = response.map { $0.id }
                dump(idList)
                self.selectedTagList.accept(idList)
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
                self.didRegisterButtonTap.accept(())
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
        self.selectedTagList.accept(id.uniqued())
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
