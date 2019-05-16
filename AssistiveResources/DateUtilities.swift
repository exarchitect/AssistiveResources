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

//func createTimeString (hours: Int, minutes: Int) -> String {
//    var startTime: String
//    var totalMinutes = hours*60 + minutes
//    let actualMinutes = totalMinutes % 60
//    var actualHours = (totalMinutes - actualMinutes) / 60
//
//    if (totalMinutes == (12*60)) {
//        return "Noon"
//    }
//    if (totalMinutes == (24*60)) {
//        return "Midnight"
//    }
//
//    if (totalMinutes > (24*60)) {
//        totalMinutes = totalMinutes % (24*60)
//        actualHours = actualHours % 24
//    }
//
//    if (totalMinutes < (12*60)) {
//        if actualMinutes == 0 {
//            startTime = "\(actualHours)am"
//        } else {
//            startTime = "\(actualHours):\(actualMinutes)am"
//        }
//    } else {
//        if actualMinutes == 0 {
//            startTime = "\(actualHours-12)pm"
//        } else {
//            startTime = "\(actualHours-12):\(actualMinutes)pm"
//        }
//    }
//    return startTime
//}
