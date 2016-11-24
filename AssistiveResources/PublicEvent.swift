//
//  PublicEvent.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


typealias EntityDescriptor = (entityName:String, entityType:Int, entityID:Int)


class PublicEvent: NSObject {

    // for backendless
    var objectId: String?
    var created: Date?
    var updated: Date?
    
    var eventTitle: String = ""
    var eventType: Int = 0
    var eventID: Int = 0
    
    var organizationName: String = ""
    var organizationType: Int = 0
    var organizationID: Int = 0
    
    var facilityName: String = ""
    var facilityType: Int = 0
    var facilityID: Int = 0
    
    var startDate: Date!
    var timeOfDayHours: Int = 0    // military
    var timeOfDayMinutes: Int = 0
    var durationMinutes: Int = 0
    
    var address: String = ""
    var directions: String = ""
    
    var eventDescriptionVerbose: String = ""
    var eventDescriptionBrief: String = ""
    
    private(set) var year: Int = 0
    private(set) var month: Int = 0
    private(set) var dayOfMonth: Int = 0
    private(set) var dayOfWeek: String = ""
    private(set) var monthAbbreviation: String = ""
    
    var whenDescription: String {
//        let startTime = militaryToAmPm(hours: timeOfDayHours, minutes: timeOfDayMinutes)
//        if durationMinutes == 0 {
//            return "Starts at " + startTime
//        } else {
//            let endTime = militaryToAmPm(hours: timeOfDayHours, minutes: timeOfDayMinutes + durationMinutes)
//            return startTime + "-" + endTime
//        }
        return "0.00-0.00"
    }
    
    
    init(event:EntityDescriptor, organization:EntityDescriptor, facility:EntityDescriptor, eventDate:Date, eventStartHour:Int, eventStartMin:Int, durationMin:Int, eventDetail:String) {
        eventTitle = event.entityName
        eventType = event.entityType
        eventID = event.entityID
        
        organizationName = organization.entityName
        organizationType = organization.entityType
        organizationID = organization.entityID
        
        facilityName = facility.entityName
        facilityType = facility.entityType
        facilityID = facility.entityID
        
        startDate = eventDate
        timeOfDayHours = eventStartHour
        timeOfDayMinutes = eventStartMin
        durationMinutes = durationMin
        
        //address = ""
        //directions = ""
        
        eventDescriptionVerbose = eventDetail
        eventDescriptionBrief = ""
        
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents(
            Set<Calendar.Component>([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,
                                     Calendar.Component.hour, Calendar.Component.minute]), from: eventDate)
        
        year = dateComponents.year!
        month = dateComponents.month!
        dayOfMonth = dateComponents.day!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let monthAbbr = dateFormatter.string(from: eventDate as Date)
        monthAbbreviation = monthAbbr.uppercased()
        
        dateFormatter.dateFormat = "EEE"
        let dayOfWk = dateFormatter.string(from: eventDate as Date)
        dayOfWeek = dayOfWk.uppercased()
    }
    
}
