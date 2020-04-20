//
//  DateUtilities.swift
//  SwiftNeed
//
//  Created by Bill Johnson on 5/26/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import Foundation
import SwiftDate

struct TimeBlockDescriptor {
    var startdatetime:Date!
    var durationMinutes: Int
    var whenDescription:String!
    var year: Int {
        return startdatetime.year
    }
    var month: Int {
        return startdatetime.month
    }
    var day: Int {
        return startdatetime.day
    }
    var hour: Int {
        return startdatetime.hour
    }
    var minute: Int {
        return startdatetime.minute
    }
    private var durationInterval:TimeInterval {
        return Double(durationMinutes * 60)
    }
    var month3Char:String {
        let monthInCaps = startdatetime.monthName(SymbolFormatStyle.short)
        return monthInCaps.uppercased()
    }
    var dayOfWeek:String {
        let dowInCaps = startdatetime.weekdayName(SymbolFormatStyle.short)
        return dowInCaps.uppercased()
    }
    
    init(date:Date, durationMin: Int)
    {
        self.startdatetime = date
        self.durationMinutes = durationMin

        var startTimeDescription:String
        var timeDescription:String
        startTimeDescription = self.startdatetime.toFormat("h:mm a")
        if (durationMin == 0) {
            timeDescription = "Starts at " + startTimeDescription
        } else {
            let endTimeDescription = self.startdatetime.addingTimeInterval(durationInterval).toFormat("h:mm a")
            timeDescription = startTimeDescription + "-" + endTimeDescription
        }
        timeDescription = timeDescription.replacingOccurrences(of: "12:00 PM", with: "Noon")
        timeDescription = timeDescription.replacingOccurrences(of: "12:00 AM", with: "Midnight")
        timeDescription = timeDescription.replacingOccurrences(of: ":00", with: "")
        timeDescription = timeDescription.replacingOccurrences(of: " PM", with: "pm")
        timeDescription = timeDescription.replacingOccurrences(of: " AM", with: "am")
        self.whenDescription = timeDescription
    }
}

func ageSince(monthOfBirth: Int, yearOfBirth: Int) -> Int {
    guard let dobApproximate = dobUsing(monthOfBirth: monthOfBirth, yearOfBirth: yearOfBirth) else {
        return 0
    }
    let ageComponents = Calendar.current.dateComponents([.year], from: dobApproximate, to: Date())
    guard let age = ageComponents.year else {
        return 0
    }
    return age
}

func dobUsing(monthOfBirth: Int, yearOfBirth: Int) -> Date? {
    let calendar = Calendar.current
    var components = DateComponents()
    components.day = 1
    components.month = monthOfBirth
    components.year = yearOfBirth
    guard let dobApproximate = calendar.date(from: components) else {
        return nil
    }
    return dobApproximate
}

extension Date {
    func matchesCurrentMonth() -> Bool {
        let calendar = Calendar.current
        let targetDateComponents = calendar.dateComponents([.month], from: self)
        let currentDateComponents = calendar.dateComponents([.month], from: Date())
        guard let targetMonth = targetDateComponents.month, let currentMonth = currentDateComponents.month else {
            return false
        }
        return targetMonth == currentMonth
    }
}
