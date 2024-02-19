//
//  DateManager.swift
//  Kerdy
//
//  Created by 이동현 on 1/1/24.
//

import Foundation

final class DateManager {
    static let shared = DateManager()
    
    private init() {}
        
    func calculateDaysDifference(_ from: Date) -> Int {
        let todayDate = Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: todayDate, to: from)
        return components.day ?? 0
    }
    
    func getDdayString(_ from: String) -> String {
        let format = "yyyy-MM-dd"
        let targetDate = Convert.convertStringToDate(date: from, format: format)
        let dateDifference = calculateDaysDifference(targetDate)
        
        if dateDifference < 0 {
            return "D\(dateDifference)"
        } else if dateDifference > 0 {
            return "D+\(dateDifference)"
        } else {
            return "D-day"
        }
    }
    
    func getApplyDateString(startDate: String, endDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy:MM:dd:HH:mm:ss"
        
        let startDateFormatter = DateFormatter()
        startDateFormatter.locale = Locale(identifier: "ko_KR")
        startDateFormatter.dateFormat = "M월 d일(EEE)"
        
        let endDateFormatter = DateFormatter()
        endDateFormatter.locale = Locale(identifier: "ko_KR")
        endDateFormatter.dateFormat = "M월 d일(EEE) HH:mm"
        
        guard
            let startDate = inputFormatter.date(from: startDate),
            let endDate = inputFormatter.date(from: endDate)
        else { return "" }
        
        let startString = startDateFormatter.string(from: startDate)
        let endString = endDateFormatter.string(from: endDate)
        return "\(startString) ~ \(endString)"
    }
    
    func getProgressDateString(startDate: String, endDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy:MM:dd:HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "M월 d일(EEE)"
        outputFormatter.locale = Locale(identifier: "ko_KR")
        
        guard
            let startDate = inputFormatter.date(from: startDate),
            let endDate = inputFormatter.date(from: endDate)
        else { return "" }
        
        let startString = outputFormatter.string(from: startDate)
        let endString = outputFormatter.string(from: endDate)
        return "\(startString) ~ \(endString)"
    }
}
