//
//  DateUtilities.swift
//  SwiftNeed
//
//  Created by Bill Johnson on 5/26/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import Foundation


//extension Date
//{
//    
//    init(dateFromMDY: String) {
//        let dateStringFormatter = DateFormatter()
//        dateStringFormatter.dateFormat = "MM-dd-yyyy"
//        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
//        let d = dateStringFormatter.date(from: dateFromMDY)!
//        self(timeInterval:0, since:d)
//    }
//    
//}


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
