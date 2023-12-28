//
//  MemberInfo.swift
//  Kerdy
//
//  Created by 최다경 on 12/3/23.
//
import Foundation

struct MemberInfo: Codable {
    var name: String
    var activityIds: [Int]?

    init() {
        self.name = ""
        self.activityIds = []
    }
}

