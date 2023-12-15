//
//  CommentsResponseDTO.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/10/23.
//

import Foundation

// MARK: - CommentsResponseDTOElement

struct CommentsResponseDTO: Codable, Hashable {
    
    let parentComment: Comment
    let childComments: [Comment]
}

// MARK: - Comment

struct Comment: Codable, Hashable, SettingWrittenProtocol {

    var uuid = UUID()
    let content: String
    let commentID: Int
    let parentID: Int?
    let feedID: Int
    let title: String
    let createdAt, updatedAt: String
    let memberID: Int
    let memberImageURL, memberName: String
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
            return convertDate(date: createdAt)
        } else {
            return convertDate(date: updatedAt) + " 수정됨"
        }
    }
}
