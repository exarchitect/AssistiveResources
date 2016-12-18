//
//  DateUtilities.swift
//  SwiftNeed
//
//  Created by Bill Johnson on 5/26/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import Foundation


func dateFromMoDyYr (dateString: String) -> Date
{
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "MM-dd-yyyy"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        return dateStringFormatter.date(from: dateString)! 
}


struct DateTimeDuration {
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var duration: Int
    
    var startdatetime:Date!
    
    var timeRangeDescription:String!        // 1-3pm
    var monthAbbreviation:String!
    var dayOfWeek:String!

    //init(yr:Int, mo:Int, dy:Int)
    //{
    //    self.init(yr: yr, mo: mo, dy:dy, hr: 0, min: 0, durationMin:0)
    //}

    init(yr:Int, mo:Int, dy:Int, hr: Int, min: Int, durationMin: Int)
    {
        year = yr
        month = mo
        day = dy
        hour = hr
        minute = min
        duration = durationMin
        
        let startcomponents = DateComponents(calendar: nil,
                                        timeZone: nil,
                                        era: nil,
                                        year: yr,
                                        month: mo,
                                        day: dy,
                                        hour: hr,
                                        minute: min,
                                        second: nil,
                                        nanosecond: nil,
                                        weekday: nil,
                                        weekdayOrdinal: nil,
                                        quarter: nil,
                                        weekOfMonth: nil,
                                        weekOfYear: nil,
                                        yearForWeekOfYear: nil)

        self.startdatetime = Calendar.current.date(from: startcomponents)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let monthAbbr = dateFormatter.string(from: self.startdatetime)
        self.monthAbbreviation = monthAbbr.uppercased()
        
        dateFormatter.dateFormat = "EEE"
        let dayOfWk = dateFormatter.string(from: self.startdatetime)
        self.dayOfWeek = dayOfWk.uppercased()

        self.timeRangeDescription = "1-3pm"
}
}

//func militaryToAmPm (hours: Int, minutes: Int) -> String {
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
