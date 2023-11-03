//
//  Event.swift
//  Temp
//
//  Created by 이동현 on 10/29/23.
//

import UIKit

struct Event {
    var name: String
    var eventStatus: EventStatus // response를 보고 수정 예정
    var img: UIImage
    var tags: [String]
}

enum EventStatus: Int {
    case inProgress
    case isFinished
    case isPlanned
}
