//
//  BlockManager.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import UIKit

import Moya
import RxSwift

protocol BlockManagerType {
    
    func getBlockList() -> Single<[BlockReponseDTO]>
    func deleteBlock(id: Int) -> Single<Void>
    func postBolck(id: Int) -> Single<Void>
}

final class BlockManager: Networking, BlockManagerType {
    
    typealias API = BlockAPI
    
    static let shared = BlockManager()
    
    private let disposeBag = DisposeBag()
    
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private init () {}
    
    func getBlockList() -> Single<[BlockReponseDTO]> {
        return provider
            .request(.getBlockList)
            .map([BlockReponseDTO].self)
    }
    
    func deleteBlock(id: Int) -> Single<Void> {
        return provider
            .request(.deleteBlock(id: id))
            .map { _ in }
    }
    
    func postBolck(id: Int) -> Single<Void> {
        return provider
            .request(.postBlock(id: id))
            .map { _ in }
    }
}
