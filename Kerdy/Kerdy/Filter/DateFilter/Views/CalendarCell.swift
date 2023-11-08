//
//  CalendarCell.swift
//  Kerdy
//
//  Created by 이동현 on 11/8/23.
//

import Foundation
import FSCalendar

class CalendarCell: FSCalendarCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
