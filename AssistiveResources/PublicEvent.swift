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
    
    var organizationDescriptor: EntityDescriptor
    var facilityDescriptor: EntityDescriptor
    
    var eventDate: DateTimeDuration
    
    var address: String = ""
    var directions: String = ""
    
    var eventDescriptionVerbose: String = ""
    var eventDescriptionBrief: String = ""
        
    init(event:EntityDescriptor, organization:EntityDescriptor, facility:EntityDescriptor, eventDate:DateTimeDuration, eventDetail:String) {
        self.eventTitle = event.entityName
        self.eventType = event.entityType
        self.eventID = event.entityID
        
        self.organizationDescriptor = organization
        self.facilityDescriptor = facility
        
        self.eventDate = eventDate
        
        //address = ""
        //directions = ""
        
        eventDescriptionVerbose = eventDetail
        eventDescriptionBrief = ""
    }
    
}
