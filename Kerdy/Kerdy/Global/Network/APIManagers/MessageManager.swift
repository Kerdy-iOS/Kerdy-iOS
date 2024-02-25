//
//  MessageManager.swift
//  Kerdy
//
//  Created by 이동현 on 2/25/24.
//

import Foundation
import RxSwift

final class MessageManager {
    typealias API = MessageAPI
    static let shared = MessageManager()
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private init() {}
    
    func postMessage(
        senderId: Int,
        receiverId: Int,
        content: String
    )  -> Single<MessageResponseDTO> {
        provider.request(.postMessge(
            senderId: senderId,
            receiverId: receiverId,
            content: content
        ))
        .map(MessageResponseDTO.self)
    }
}
