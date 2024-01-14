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
    
    func getUserComments(id: Int) -> Single<[CommentsResponseDTO]>
    func getDetailComments(commentID: Int) -> Single<CommentsResponseDTO>
    func postComments(request: CommentsRequestDTO) -> Single<Comment>
    func patchComments(commentID: Int, content: String) -> Single<Comment>
    func deleteComments(commentID: Int) -> Single<Void>
}

final class CommentManager: Networking, CommentManagerType {
    
    typealias API = CommentAPI
    
    static let shared = CommentManager()
    
    private let disposeBag = DisposeBag()
    
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private init () {}
    
    func getUserComments(id: Int) -> Single<[CommentsResponseDTO]> {
        return provider
            .request(.getUserComments(memberID: id))
            .map([CommentsResponseDTO].self)
    }
    
    func getDetailComments(commentID: Int) -> Single<CommentsResponseDTO> {
        return provider
            .request(.getDetailComments(commentID: commentID))
            .map(CommentsResponseDTO.self)
    }
    
    func postComments(request: CommentsRequestDTO) -> Single<Comment> {
        return provider
            .request(.postComments(request: request))
            .map(Comment.self)
    }
    
    func patchComments(commentID: Int, content: String) -> Single<Comment> {
        return provider
            .request(.patchcomments(commentID: commentID, content: content))
            .map(Comment.self)
    }
    
    func deleteComments(commentID: Int) -> RxSwift.Single<Void> {
        return provider
            .request(.deleteComment(commentID: commentID))
            .map { _ in }
    }
}
