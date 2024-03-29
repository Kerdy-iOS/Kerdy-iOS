//
//  CommentsResponseDTO.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/10/23.
//

import Foundation

// MARK: - CommentsResponseDTOElement

struct CommentsResponseDTO: Codable, Hashable, Equatable {
    
    let parentComment: Comment
    let childComments: [Comment]
}

// MARK: - Comment

struct Comment: Codable, Hashable, SettingWrittenProtocol, Equatable {

    var uuid = UUID()
    var content: String
    let commentID: Int?
    let parentID: Int?
    let feedID: Int
    let title: String
    var createdAt, updatedAt: String
    let memberID: Int
    let memberImageURL: String
    let memberName: String?
    let deleted: Bool

    enum CodingKeys: String, CodingKey {
        case content
        case commentID = "commentId"
        case parentID = "parentId"
        case feedID = "feedId"
        case title = "feedTitle"
        case createdAt, updatedAt
        case memberID = "memberId"
        case memberImageURL = "memberImageUrl"
        case memberName, deleted
    }
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    var updateDate: String {
        if createdAt == updatedAt {
            return Convert.convertDate(date: createdAt, format: "yy.MM.dd")
        } else {
            return Convert.convertDate(date: updatedAt, format: "yy.MM.dd") + " 수정됨"
        }
    }
    
    func timeAgoSinceDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd:HH:mm:ss"
        
        guard let createdDate = dateFormatter.date(from: createdAt) else { return "" }

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.calendar?.locale = Locale(identifier: "ko_KR")

        guard let timeAgo = formatter.string(from: createdDate, to: Date()) else { return "" }
        let modifiedText = (createdAt != updatedAt) ? " 수정됨" : ""
            
        return timeAgo + " 전" + modifiedText
    }
}
