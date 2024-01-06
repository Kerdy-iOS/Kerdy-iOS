//
//  EventFilter.swift
//  Kerdy
//
//  Created by 이동현 on 12/15/23.
//

import Foundation

struct EventFilter: Equatable {
    var startDate: String?
    var endDate: String?
    var statuses: [String]?
    var keyword: String?
    var tags: [String]?
    
    var combinedStrings: [FilterItem] {
        var combined: [FilterItem] = []
        var dateString = ""
        
        if let startDate = startDate {
            var date = String(startDate.dropFirst(2))
            date = date.replacingOccurrences(of: "-", with: ".")
            dateString = "\(date) -"
            
            if let endDate = endDate {
                var date = String(endDate.dropFirst(2))
                date = date.replacingOccurrences(of: "-", with: ".")
                dateString += " \(date)"
            }
        }
        if !dateString.isEmpty {
            combined.append(FilterItem(type: .date, name: dateString))
        }
    
        if let statuses = statuses {
            combined.append(contentsOf: statuses.map {
                FilterItem(type: .progress, name: $0)
            })
        }
        
        if let tags = tags {
            combined.append(contentsOf: tags.map {
                FilterItem(type: .tag, name: $0)
            })
        }

        return combined
    }
}

struct FilterItem: Hashable {
    let type: FilterType
    let name: String
}
