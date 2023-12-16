//
//  CommentManager.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import UIKit

import Moya
import RxSwift

protocol CommentManagerType {
    
    func getUserCommnets(id: Int) -> Single<[CommentsResponseDTO]>
}

final class CommentManager: Networking, CommentManagerType {
    
    typealias API = CommentAPI
    
    static let shared = CommentManager()
    
    private let disposeBag = DisposeBag()
    
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private init () {}
    
    func getUserCommnets(id: Int) -> Single<[CommentsResponseDTO]> {
        return provider
            .request(.getAllComments(memberID: id))
            .map([CommentsResponseDTO].self)
    }
}
