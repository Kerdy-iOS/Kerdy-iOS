//
//  ArticleResponseDTO.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/10/23.
//

import Foundation

// MARK: - ArticleResponseDTOElement

struct ArticleResponseDTO: Codable, Hashable, SettingWrittenProtocol {
    
    var uuid = UUID()
    let id: Int
    let title, content: String
    let writerID: Int
    let images: [String]
    let commentCount: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, title, content
        case writerID = "writerId"
        case images, commentCount, createdAt, updatedAt
    }
    
    static func == (lhs: ArticleResponseDTO, rhs: ArticleResponseDTO) -> Bool {
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

extension ArticleResponseDTO {
    
    static func dummy() -> [ArticleResponseDTO] {
        return [ArticleResponseDTO(id: 1, title: "해커톤 프로그램 행사 기대 됩니다! 저번에 못가서 아쉬웠는데 올 해 열려서", content: "해커톤 프로그램 행사 기대 됩니다! 저번에 못가서 아쉬웠는데 올 해 열려서 좋네여여ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ", writerID: 1, images: [], commentCount: 1, createdAt: "111", updatedAt: "111"),
                ArticleResponseDTO(id: 2, title: "bbb", content: "해커톤 프로그램 행사 기대 됩니다! 저번에 못가서 아쉬웠는데 올 해 열려서 좋네여여ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ", writerID: 1, images: [], commentCount: 1, createdAt: "111", updatedAt: "111"),
                ArticleResponseDTO(id: 3, title: "ccc", content: "dafa", writerID: 1, images: [], commentCount: 1, createdAt: "111", updatedAt: "113"),
                ArticleResponseDTO(id: 4, title: "ddd", content: "해커톤 프로그램 행사 기대 됩니다! 저번에 못가서 아쉬웠는데 올 해 열려서 좋네여여ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ", writerID: 1, images: [], commentCount: 1, createdAt: "111", updatedAt: "131")
        ]
    }
}
