//
//  ChatLogForDay.swift
//  Kerdy
//
//  Created by 이동현 on 2/25/24.
//

import Foundation

struct ChatLogsForDay: Equatable {
    let date: String
    var messages: [MessageRoomResponseDTO]
}
