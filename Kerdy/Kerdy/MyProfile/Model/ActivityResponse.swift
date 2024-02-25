//
//  ActivityModel.swift
//  Kerdy
//
//  Created by 최다경 on 1/6/24.
//

import Foundation

struct ActivityResponse: Codable, Hashable {
    let id: Int
    let activityType: String
    let name: String
}
