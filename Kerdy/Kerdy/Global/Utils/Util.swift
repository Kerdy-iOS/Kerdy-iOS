//
//  Util.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/11/23.
//

import Foundation

struct Convert {
    
    static func convertDate(date: String, format: String) -> String {
        let inputString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd:HH:mm:ss"
        
        if let date = dateFormatter.date(from: inputString) {
            dateFormatter.dateFormat = format
            let outputString = dateFormatter.string(from: date)
            return outputString
        }
        return date
    }
    
    static func convertStringToDate(date: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date) ?? Date()
    }
}

func convertDateToTime(date: String) -> String {
    let inputString = date
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "yyyy:MM:dd:HH:mm:ss"
    
    if let date = dateFormatter.date(from: inputString) {
        dateFormatter.dateFormat = "a h:mm"
        let outputString = dateFormatter.string(from: date)
        return outputString
    }
    return date
}
