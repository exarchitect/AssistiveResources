//
//  PublicEvent.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


typealias EntityDescriptor = (entityName:String, entityType:EntityType, entityID:Int)


class PublicEvent: NSObject {

    // for backendless
    var objectId: String?
    var created: Date?
    var updated: Date?
    
    var eventTitle: String = ""
    var eventType: EntityType = EntityType.Event
    var eventID: Int = 0
    
    var organizationName: String = ""
    var organizationType: EntityType = EntityType.Organization
    var organizationID: Int = 0
    
    var facilityName: String = ""
    var facilityType: EntityType = EntityType.Facility
    var facilityID: Int = 0
    
    var eventDate: DateTimeDuration
    
    var address: String = ""
    var directions: String = ""
    
    var eventDescriptionVerbose: String = ""
    var eventDescriptionBrief: String = ""
        
    init(event:EntityDescriptor, organization:EntityDescriptor, facility:EntityDescriptor, eventDate:DateTimeDuration, eventDetail:String) {
        self.eventTitle = event.entityName
        self.eventType = event.entityType
        self.eventID = event.entityID
        
        self.organizationName = organization.entityName
        self.organizationType = organization.entityType
        self.organizationID = organization.entityID
        
        self.facilityName = facility.entityName
        self.facilityType = facility.entityType
        self.facilityID = facility.entityID
        
        self.eventDate = eventDate
        
        //address = ""
        //directions = ""
        
        eventDescriptionVerbose = eventDetail
        eventDescriptionBrief = ""
/*
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
 */
    }
    
}
