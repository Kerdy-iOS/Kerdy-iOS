//
//  BoardListModel.swift
//  Kerdy
//
//  Created by 이동현 on 11/24/23.
//

import UIKit

struct PostListModel {
    let title: String
    let content: String
    let image: UIImage?
    let date: Date
    let isModified: Bool
    let commentCnt: Int
    let likeCnt: Int?
}
