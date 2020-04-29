//
//  DateUtilities.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/26/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import Foundation
import SwiftDate

struct TimeBlock {
    var startDateTime: Date!
    var durationMinutes: Int
    var rangeDescription: String!
    var year: Int {
        return startDateTime.year
    }
    var month: Int {
        return startDateTime.month
    }
    var day: Int {
        return startDateTime.day
    }
    var hour: Int {
        return startDateTime.hour
    }
    var minute: Int {
        return startDateTime.minute
    }
    var monthAbbreviation: String {
        let monthInCaps = startDateTime.monthName(SymbolFormatStyle.short)
        return monthInCaps.uppercased()
    }
    var weekdayAbbreviation: String {
        let dowInCaps = startDateTime.weekdayName(SymbolFormatStyle.short)
        return dowInCaps.uppercased()
    }
    
    init(date:Date, durationMin: Int)
    {
        self.startDateTime = date
        self.durationMinutes = durationMin
        self.rangeDescription = timeRange(date: date, durationInMinutes: durationMin)
    }
}

func timeRange(date: Date, durationInMinutes: Int) -> String {
    var startTimeDescription: String
    var timeDescription: String
    startTimeDescription = date.toFormat("h:mm a")
    if (durationInMinutes == 0) {
        timeDescription = "Starts at " + startTimeDescription
    } else {
        let durationInterval = Double(durationInMinutes * 60)
        let endTimeDescription = date.addingTimeInterval(durationInterval).toFormat("h:mm a")
        timeDescription = startTimeDescription + "-" + endTimeDescription
    }
    timeDescription = timeDescription.replacingOccurrences(of: "12:00 PM", with: "Noon")
    timeDescription = timeDescription.replacingOccurrences(of: "12:00 AM", with: "Midnight")
    timeDescription = timeDescription.replacingOccurrences(of: ":00", with: "")
    timeDescription = timeDescription.replacingOccurrences(of: " PM", with: "pm")
    timeDescription = timeDescription.replacingOccurrences(of: " AM", with: "am")
    return timeDescription
}

func ageSince(monthOfBirth: Int, yearOfBirth: Int) -> Int {
    guard (1 ... 12).contains(monthOfBirth), (1900 ... 2100).contains(yearOfBirth) else {
        return 0
    }
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
    guard (1 ... 12).contains(monthOfBirth), (1900 ... 2100).contains(yearOfBirth) else {
        return nil
    }
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
