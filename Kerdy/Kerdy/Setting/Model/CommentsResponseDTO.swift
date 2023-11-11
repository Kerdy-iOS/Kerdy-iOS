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

typealias CommentsDTO = [CommentsResponseDTO]

extension CommentsDTO {
    
    static func dummy() -> CommentsDTO {
        return [CommentsResponseDTO(parentComment: .init(content: "부모댓글1", commentID: 5, parentID: nil, feedID: 1, title: "feedTitle", createdAt: "2023:11:08:01:36:36", updatedAt: "2023:11:08:01:36:36", memberID: 1, memberImageURL: "이미지", memberName: "이름1", deleted: false), childComments: []),
                CommentsResponseDTO(parentComment: .init(content: "부모댓글1", commentID: 5, parentID: nil, feedID: 1, title: "feedTitle", createdAt: "2023:11:08:01:36:36", updatedAt: "2023:11:08:02:36:36", memberID: 1, memberImageURL: "이미지", memberName: "이름1", deleted: false), childComments: [.init(content: "부모댓글1에 대한 자식댓글1", commentID: 2, parentID: 1, feedID: 1, title: "feedTitle", createdAt: "2023:11:08:01:36:36", updatedAt: "2023:11:08:01:36:36", memberID: 1, memberImageURL: "", memberName: "", deleted: false)]),
                CommentsResponseDTO(parentComment: .init(content: "부모댓글1", commentID: 5, parentID: nil, feedID: 1, title: "feedTitle", createdAt: "2023:11:08:01:36:36", updatedAt: "2023:11:08:02:36:36", memberID: 1, memberImageURL: "이미지", memberName: "이름1", deleted: false), childComments: [.init(content: "부모댓글1에 대한 자식댓글1", commentID: 2, parentID: 1, feedID: 1, title: "feedTitle", createdAt: "2023:11:08:01:36:36", updatedAt: "2023:11:08:01:36:36", memberID: 1, memberImageURL: "", memberName: "", deleted: false), .init(content: "부모댓글1에 대한 자식댓글1", commentID: 2, parentID: 1, feedID: 1, title: "feedTitle", createdAt: "2023:11:08:01:36:36", updatedAt: "2023:11:08:01:36:36", memberID: 1, memberImageURL: "", memberName: "", deleted: false)])
        ]
    }
}
