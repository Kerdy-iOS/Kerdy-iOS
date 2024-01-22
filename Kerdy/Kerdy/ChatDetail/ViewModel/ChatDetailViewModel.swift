//
//  ChatDetailViewModel.swift
//  Kerdy
//
//  Created by 이동현 on 1/21/24.
//

import Foundation

final class ChatDetailViewModel {
    private(set) var interlocutor: String = "receiver" //임시
    let dummyData: [MessageRoomResponseDTO] = [
        MessageRoomResponseDTO(
            id: 1,
            sender: Sender(
                id: 1,
                name: "sender",
                description: "Description1",
                imageURL: "https://github.image/1",
                githubURL: "https://github.com/user1"
            ),
            content: ".sssdadsa,",
            createdAt: "2023:12:01:11:22:59"
        ),
        MessageRoomResponseDTO(
            id: 2,
            sender: Sender(
                id: 1,
                name: "sender",
                description: "Description2",
                imageURL: "https://github.image/2",
                githubURL: "https://github.com/user2"
            ),
            content: ".asdadas",
            createdAt: "2023:12:01:11:22:59"
        ),
        MessageRoomResponseDTO(
            id: 3,
            sender: Sender(
                id: 1,
                name: "sender",
                description: "Description3",
                imageURL: "https://github.image/3",
                githubURL: "https://github.com/user3"
            ),
            content: "Content3",
            createdAt: "2023:12:03:11:22:59"
        ),
        MessageRoomResponseDTO(
            id: 4,
            sender: Sender(
                id: 4,
                name: "sender",
                description: "Description4",
                imageURL: "https://github.image/4",
                githubURL: "https://github.com/user4"
            ),
            content: "Conㄴㅇtent4",
            createdAt: "2023:12:03:11:22:59"
        ),
        MessageRoomResponseDTO(
            id: 5,
            sender: Sender(
                id: 2,
                name: "receiver",
                description: "Description5",
                imageURL: "https://github.image/5",
                githubURL: "https://github.com/user5"
            ),
            content: "Content5",
            createdAt: "2023:12:03:11:22:59"
        ),
        MessageRoomResponseDTO(
            id: 6,
            sender: Sender(
                id: 2,
                name: "receiver",
                description: "Description6",
                imageURL: "https://github.image/6",
                githubURL: "https://github.com/user6"
            ),
            content: "Conㅁㅁtent6",
            createdAt: "2023:12:05:11:22:59"
        ),
        MessageRoomResponseDTO(
            id: 7,
            sender: Sender(
                id: 1,
                name: "sender",
                description: "Description7",
                imageURL: "https://github.image/7",
                githubURL: "https://github.com/user7"
            ),
            content: "Content7",
            createdAt: "2023:12:05:11:22:59"
        ),
        MessageRoomResponseDTO(
            id: 8,
            sender: Sender(
                id: 1,
                name: "sender",
                description: "Description8",
                imageURL: "https://github.image/8",
                githubURL: "https://github.com/user8"
            ),
            content: "Content8 Conte nt8Co ntent8Con tent8C ontent 8Content8",
            createdAt: "2023:12:05:11:22:59"
        ),
        MessageRoomResponseDTO(
            id: 9,
            sender: Sender(
                id: 2,
                name: "receiver",
                description: "Description9",
                imageURL: "https://github.image/9",
                githubURL: "https://github.com/user9"
            ),
            content: "Content9Content 9Con tent9Cont ent9Cont ent9Con tent9Content9  Co ntent9C onte nt9Cont Content 9Content9 ent9",
            createdAt: "2023:12:05:11:22:59"
        ),
        MessageRoomResponseDTO(
            id: 10,
            sender: Sender(
                id: 2,
                name: "receiver",
                description: "Description10",
                imageURL: "https://github.image/10",
                githubURL: "https://github.com/user10"
            ),
            content: "Contㄴㄴent11Contㄴㄴent11Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11  Contㄴㄴent11  Contㄴㄴent11  Contㄴㄴent11Contㄴㄴent11  Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 ",
            createdAt: "2023:12:05:23:22:59"
        ),
        MessageRoomResponseDTO(
            id: 11,
            sender: Sender(
                id: 1,
                name: "sender",
                description: "Description11",
                imageURL: "https://github.image/11",
                githubURL: "https://github.com/user11"
            ),
            content: "Contㄴㄴent11Contㄴㄴent11Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11  Contㄴㄴent11  Contㄴㄴent11  Contㄴㄴent11Contㄴㄴent11  Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11Contㄴㄴent11Contㄴㄴent11m  print(textHe)print(textHe)print(textHe)print(textHe)print(textHe)print(textHe) print(textHe)v print(textHe) Contㄴㄴent11Contㄴㄴent11Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11  Contㄴㄴent11  Contㄴㄴent11  Contㄴㄴent11Contㄴㄴent11  Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11Contㄴㄴent11Contㄴㄴent11m  print(textHe)print(textHe)print(textHe)print(textHe)print(textHe)print(textHe) print(textHe)v print(textHe) Contㄴㄴent11Contㄴㄴent11Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11  Contㄴㄴent11  Contㄴㄴent11  Contㄴㄴent11Contㄴㄴent11  Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11 Contㄴㄴent11Contㄴㄴent11Contㄴㄴent11m  print(textHe)print(textHe)print(textHe)print(textHe)print(textHe)print(textHe) print(textHe)v print(textHe)",
            createdAt: "2023:12:10:11:22:59"
        ),
        MessageRoomResponseDTO(
            id: 12,
            sender: Sender(
                id: 2,
                name: "receiver",
                description: "Description12",
                imageURL: "https://github.image/12",
                githubURL: "https://github.com/user12"
            ),
            content: "Contenㅇㅇㅇt12",
            createdAt: "2023:12:10:11:22:59"
        ),
        MessageRoomResponseDTO(
            id: 13,
            sender: Sender(
                id: 1,
                name: "sender",
                description: "Description13",
                imageURL: "https://github.image/13",
                githubURL: "https://github.com/user13"
            ),
            content: "Conㄴㄴㄴㄴㄴㄴㅁtent13Conㄴㄴㄴㄴㄴㄴㅁtent13Conㄴㄴㄴㄴㄴㄴㅁtent13",
            createdAt: "2023:12:10:11:22:59"
        )
    ]
    var processedData: [(date: String, messages: [MessageRoomResponseDTO])] = []
    
    init() {
        processedData = groupMessagesByDate(dummyData)
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
    
    private func groupMessagesByDate(_ messages: [MessageRoomResponseDTO]) -> [(date: String, messages: [MessageRoomResponseDTO])] {
        var messagesByDate: [String: [MessageRoomResponseDTO]] = [:]
        
        for message in messages {
            let formattedDate = formatDateString(message.createdAt)
            
            if messagesByDate[formattedDate] == nil {
                messagesByDate[formattedDate] = [message]
            } else {
                messagesByDate[formattedDate]?.append(message)
            }
        }
        
        let sortedMessagesByDate = messagesByDate.sorted { $0.key < $1.key }
        let result = sortedMessagesByDate.map { (date: $0.key, messages: $0.value) }
        
        return result
    }
    
    func setInterlocutor(name: String) {
        interlocutor = name
    }
}
