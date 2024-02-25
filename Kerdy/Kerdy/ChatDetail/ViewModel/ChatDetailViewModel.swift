//
//  ChatDetailViewModel.swift
//  Kerdy
//
//  Created by 이동현 on 1/21/24.
//

import Foundation
import RxSwift
import RxRelay

final class ChatDetailViewModel {
    // MARK: - Input
    enum Input {
        case configre(roomId: String)
    }
    
    // MARK: - property
    private(set) var myId: Int?
    private let roomManager = RoomManager.shared
    private var roomRelay = BehaviorRelay<[MessageRoomResponseDTO]>(value: [])
    private(set) var chatsRelay = BehaviorRelay<[ChatLogsForDay]>(value: [])
    private var roomIdRelay = BehaviorRelay<String>(value: "")
    private var roomObservable: Observable<[MessageRoomResponseDTO]> {
        return roomRelay.asObservable().distinctUntilChanged()
    }
    var chatsObservable: Observable<[ChatLogsForDay]> {
        return chatsRelay.asObservable().distinctUntilChanged()
    }
    private var roomIdObservable: Observable<String> {
        return roomIdRelay.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - initialize
    init() {
        myId = Int(KeyChainManager.read(forkey: .memberId) ?? "-1")
        binding()
    }
    
    // MARK: - action
    func action(_ input: Input) {
        switch input {
        case .configre(roomId: let roomId):
            configure(roomId: roomId)
        }
    }
}


// MARK: - binding
extension ChatDetailViewModel {
    func binding() {
        roomIdObservable
            .subscribe { [weak self] id in
                self?.getRoomDetail(roomId: id)
            }
            .disposed(by: disposeBag)
        
        roomObservable
            .subscribe { [weak self] messages in
                let chatLogs = self?.groupMessagesByDate(messages) ?? []
                self?.chatsRelay.accept(chatLogs)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - method
extension ChatDetailViewModel {
    private func configure(roomId: String) {
        roomIdRelay.accept(roomId)
    }
    
    private func getRoomDetail(roomId: String) {
        roomManager.getRoomByUUID(roomId: roomId)
            .subscribe { [weak self] roomDetail in
                self?.roomRelay.accept(roomDetail)
            }
            .disposed(by: disposeBag)
    }

    private func groupMessagesByDate(_ messages: [MessageRoomResponseDTO]) -> [ChatLogsForDay] {
        let groupedByDate = Dictionary(grouping: roomRelay.value) { message -> String in
            let formattedDate = formatDateString(message.createdAt)
            return formattedDate
        }
        
        var chatLogsForDays: [ChatLogsForDay] = []
        
        for (date, messages) in groupedByDate {
            let chatLogsForDay = ChatLogsForDay(date: date, messages: messages)
            chatLogsForDays.append(chatLogsForDay)
        }

        return chatLogsForDays.sorted { $0.date < $1.date }
    }
    
    private func formatDateString(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy:MM:dd:HH:mm:ss"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "yyyy년 MM월 dd일"
            return formatter.string(from: date)
        }
        
        return ""
    }
}
