//
//  ChatViewModel.swift
//  Kerdy
//
//  Created by 이동현 on 1/21/24.
//

import Foundation

final class ChatViewModel {
    func convertDateString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd:HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            let timeFormatter = DateFormatter()
            timeFormatter.locale = Locale(identifier: "ko_KR")
            timeFormatter.dateFormat = "a h:mm"
            
            let formattedTime = timeFormatter.string(from: date)
            
            return formattedTime
        } else {
            return nil
        }
    }
}
