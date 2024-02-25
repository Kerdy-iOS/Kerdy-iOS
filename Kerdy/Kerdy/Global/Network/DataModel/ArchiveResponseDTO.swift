//
//  ArchiveResponseDTO.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/23/24.
//

import Foundation

// MARK: - ArchiveResponseDTO

struct ArchiveResponseDTO: Decodable, Equatable {
    let notificationID: Int
    let type: TypeEnum
    let notificationInformation: NotificationInformation
    let redirectID, receiverID: Int
    let createdAt: String
    let isRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case notificationID = "notificationId"
        case type, notificationInformation
        case redirectID = "redirectId"
        case receiverID = "receiverId"
        case createdAt, isRead
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.notificationID = try container.decode(Int.self, forKey: .notificationID)
        self.type = try container.decode(TypeEnum.self, forKey: .type)
        self.notificationInformation = try NotificationInformation(from: decoder)
        self.redirectID = try container.decode(Int.self, forKey: .redirectID)
        self.receiverID = try container.decode(Int.self, forKey: .receiverID)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.isRead = try container.decode(Bool.self, forKey: .isRead)
    }
    
    enum NotificationInformation: Decodable, Equatable {
        case comment(CommentNotificationInformation)
        case event(EventNotificationInformation)
        
        init(from decoder: Decoder) throws {
            let type = try decoder.container(keyedBy: CodingKeys.self).decode(TypeEnum.self, forKey: .type)
            
            switch type {
            case .comment:
                self = .comment(try CommentNotificationInformation(from: decoder))
            case .event:
                self = .event(try EventNotificationInformation(from: decoder))
            }
        }
    }
    
    var convertDate: String {
        return Convert.convertDate(date: createdAt, format: "MM.dd")
    }
}

struct CommentNotificationInformation: Decodable, Equatable {
    let title: String?
    let content: String?
    let writer: String?
    let profile: String?
    let feedID: Int?
    let commentID: Int?

    enum CodingKeys: String, CodingKey {
        case notificationInformation
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let commentsContainer = try container.decode(String.self, forKey: .notificationInformation)
        
        let innerDecoder = JSONDecoder()
        let innerData = commentsContainer.data(using: .utf8)
        
        title = try innerDecoder.decode(CommentsContainer.self, from: innerData!).title
        content = try innerDecoder.decode(CommentsContainer.self, from: innerData!).content
        writer = try innerDecoder.decode(CommentsContainer.self, from: innerData!).writer
        profile = try innerDecoder.decode(CommentsContainer.self, from: innerData!).profile
        feedID = try innerDecoder.decode(CommentsContainer.self, from: innerData!).feedID
        commentID = try innerDecoder.decode(CommentsContainer.self, from: innerData!).commentID
    }

    private struct CommentsContainer: Decodable {
        let title: String?
        let content: String?
        let writer: String?
        let profile: String?
        let feedID: Int?
        let commentID: Int?

        enum CodingKeys: String, CodingKey {
            case title
            case content
            case writer
            case profile = "writerImageUrl"
            case feedID = "feedId"
            case commentID = "parentCommentId"
        }
    }
}

struct EventNotificationInformation: Decodable, Equatable {
    let title: String?

    enum CodingKeys: String, CodingKey {
        case notificationInformation
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let eventContainer = try container.decode(String.self, forKey: .notificationInformation)

        let innerDecoder = JSONDecoder()
        let innerData = eventContainer.data(using: .utf8)
        title = try innerDecoder.decode(EventTitleContainer.self, from: innerData!).title
    }

    private struct EventTitleContainer: Decodable {
        let title: String?
    }
}

enum TypeEnum: String, Codable {
    case comment = "COMMENT"
    case event = "EVENT"
}
