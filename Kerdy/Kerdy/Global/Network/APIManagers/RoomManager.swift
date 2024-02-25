//
//  RoomManager.swift
//  Kerdy
//
//  Created by 이동현 on 2/25/24.
//

import Foundation
import RxSwift

final class RoomManager {
    typealias API = RoomAPI
    static let shared = RoomManager()
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private init() {}
    
    func getRooms(memberId: Int) -> Single<[MessageRoomsResponseDTO]> {
        provider.request(.getRooms(memberId: memberId))
            .map([MessageRoomsResponseDTO].self)
    }
    
    func getRoomByUUID(roomId: String) -> Single<[MessageRoomResponseDTO]> {
        provider.request(.getRoomByUUID(uuid: roomId))
            .map([MessageRoomResponseDTO].self)
    }
    
    func getRoomByUserId(receiverId: Int) -> Single<[MessageRoomResponseDTO]> {
        provider.request(.getRoomByUserId(receiverId: receiverId))
            .map([MessageRoomResponseDTO].self)
    }
}
