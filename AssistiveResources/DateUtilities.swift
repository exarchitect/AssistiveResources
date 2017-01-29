//
//  DateUtilities.swift
//  SwiftNeed
//
//  Created by Bill Johnson on 5/26/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import Foundation


struct EventDescriptor {
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var duration: Int
    
    var startdatetime:Date!
    
    var whenDescription:String!        // 1pm-3pm
    private var startTimeDescription:String!        // 1pm
    var monthAbbreviation:String!
    var dayOfWeek:String!
    
    init(date:Date, durationMin: Int)
    {
        let calendar = NSCalendar.current
        self.startdatetime = date
        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
        self.hour = calendar.component(.hour, from: date)
        self.minute = calendar.component(.minute, from: date)

        self.duration = durationMin
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let monthAbbr = dateFormatter.string(from: self.startdatetime)
        self.monthAbbreviation = monthAbbr.uppercased()
        
        dateFormatter.dateFormat = "EEE"
        let dayOfWk = dateFormatter.string(from: self.startdatetime)
        self.dayOfWeek = dayOfWk.uppercased()
        
        self.startTimeDescription = createTimeString(hours: hour, minutes: minute)
        if (durationMin == 0) {
            self.whenDescription = "Starts at " + self.startTimeDescription
        } else {
            let endTime =  createTimeString(hours: hour, minutes: (minute+durationMin))
            self.whenDescription = self.startTimeDescription + "-" + endTime
        }
    }
}

struct DateTimeDuration {
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var duration: Int
    
    var startdatetime:Date!
    
    var whenDescription:String!        // 1pm-3pm
    private var startTimeDescription:String!        // 1pm
    var monthAbbreviation:String!
    var dayOfWeek:String!
    
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
        
        self.startTimeDescription = createTimeString(hours: hour, minutes: minute)
        if (durationMin == 0) {
            self.whenDescription = "Starts at " + self.startTimeDescription
        } else {
            let endTime =  createTimeString(hours: hour, minutes: (minute+durationMin))
            self.whenDescription = self.startTimeDescription + "-" + endTime
        }
    }
}

func createTimeString (hours: Int, minutes: Int) -> String {
    var startTime: String
    var totalMinutes = hours*60 + minutes
    let actualMinutes = totalMinutes % 60
    var actualHours = (totalMinutes - actualMinutes) / 60

    if (totalMinutes == (12*60)) {
        return "Noon"
    }
    if (totalMinutes == (24*60)) {
        return "Midnight"
    }

    if (totalMinutes > (24*60)) {
        totalMinutes = totalMinutes % (24*60)
        actualHours = actualHours % 24
    }

    if (totalMinutes < (12*60)) {
        if actualMinutes == 0 {
            startTime = "\(actualHours)am"
        } else {
            startTime = "\(actualHours):\(actualMinutes)am"
        }
    } else {
        if actualMinutes == 0 {
            startTime = "\(actualHours-12)pm"
        } else {
            startTime = "\(actualHours-12):\(actualMinutes)pm"
        }
    }
    return startTime
}


extension Date {
    static func dateFromComponents(yr:Int, mo:Int, dy:Int, hr: Int, min: Int) -> Date? {
        
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
        
        return Calendar.current.date(from: startcomponents)
    }
}

