//
//  EventFilter.swift
//  Kerdy
//
//  Created by 이동현 on 12/15/23.
//

import Foundation

struct EventFilter: Equatable {
    var startDate: Date?
    var endDate: Date?
    var statuses: [String]?
    var keyword: String?
}
