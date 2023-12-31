//
//  Util.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/11/23.
//

import Foundation

func convertDate(date: String) -> String {
    let inputString = date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy:MM:dd:HH:mm:ss"

    if let date = dateFormatter.date(from: inputString) {
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let outputString = dateFormatter.string(from: date)
        return outputString
    }
    return date
}
