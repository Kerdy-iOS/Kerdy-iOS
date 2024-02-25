//
//  ChatViewModel.swift
//  Kerdy
//
//  Created by 이동현 on 1/21/24.
//

import Foundation
import RxSwift
import RxRelay

final class ChatViewModel {
    // MARK: - property
    private let roomManager = RoomManager.shared
    private let disposeBag = DisposeBag()
    private(set) var roomsRelay = BehaviorRelay<[MessageRoomsResponseDTO]>(value: [])
    var roomsObservable: Observable<[MessageRoomsResponseDTO]> {
        return roomsRelay.asObservable().distinctUntilChanged()
    }
    
    // MARK: - initialize
    init() {
        getRooms()
    }
    
    // MARK: - Input
    enum Input {
        case refresh
    }
    
    func action(_ input: Input) {
        switch input {
        case .refresh:
            getRooms()
        }
    }
}

// MARK: - Method
extension ChatViewModel {
    private func getRooms() {
        guard
            let memberId = KeyChainManager.read(forkey: .memberId),
            let id = Int(memberId)
        else { return }
        
        roomManager.getRooms(memberId: id)
            .subscribe { [weak self] rooms in
                self?.roomsRelay.accept(rooms)
            }
            .disposed(by: disposeBag)
    }
}
