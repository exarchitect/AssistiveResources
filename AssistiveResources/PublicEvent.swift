//
//  PublicEvent.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift


typealias EntityDescriptor = (entityName:String, entityID:Int)



class StoredEvent: Object {
    dynamic var objectId: String?
    dynamic var created: Date?
    dynamic var updated: Date?

    dynamic var eventTitle: String = ""
    dynamic var eventID: Int = 0
    dynamic var organizationTitle: String = ""
    dynamic var organizationID: Int = 0
    dynamic var facilityTitle: String!
    dynamic var facilityID: Int = 0
    dynamic var eventDate: Date!
    dynamic var durationMinutes: Int = 0
    dynamic var eventDescriptionBrief: String = ""

    var eventDescriptor: EventDescriptor?

    convenience required init(event:EntityDescriptor, organization:EntityDescriptor, facility:EntityDescriptor, eventStart:Date, durationInMinutes:Int, eventDetail:String)
    {
        self.init()
        
        self.eventTitle = event.entityName
        self.organizationTitle = organization.entityName
        self.facilityTitle = facility.entityName
        self.eventDate = eventStart
        self.durationMinutes = durationInMinutes

        self.eventDescriptionBrief = eventDetail

        self.eventDescriptor = EventDescriptor(date: eventDate, durationMin: durationInMinutes)

        //address = ""
        //directions = ""
        
        //eventDescriptionVerbose = eventDetail
        //eventDescriptionBrief = ""
    }
    
    
    //Specify properties to ignore (Realm won't persist)
    
    override static func ignoredProperties() -> [String] {
        return ["eventDescriptor"]
    }
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
}


//class PublicEvent: NSObject {
//
//    // for backendless
//    dynamic var objectId: String?
//    dynamic var created: Date?
//    dynamic var updated: Date?
//    
//    var eventTitle: String = ""
//    var eventID: Int = 0
//    
//    var organizationTitle: String = ""
//    var organizationID: Int = 0
//    
//    var facilityTitle: String = ""
//    var facilityID: Int = 0
//    
//    var eventDate: Date!
//    var eventDuration: Int = 0
//    var eventDescriptor: EventDescriptor
//    
//    var address: String = ""
//    var directions: String = ""
//    
//    var eventDescriptionVerbose: String = ""
//    var eventDescriptionBrief: String = ""
//        
//    init(event:EntityDescriptor, organization:EntityDescriptor, facility:EntityDescriptor, eventStart:Date, durationInMinutes:Int, eventDetail:String) {
//        self.eventTitle = event.entityName
//        self.eventID = event.entityID
//        
//        self.organizationTitle = organization.entityName
//        self.organizationID = organization.entityID
//        
//        self.facilityTitle = facility.entityName
//        self.facilityID = facility.entityID
//        
//        self.eventDate = eventStart
//        self.eventDuration = durationInMinutes
//        self.eventDescriptor = EventDescriptor(date: eventDate, durationMin: durationInMinutes)
//        
//        //address = ""
//        //directions = ""
//        
//        eventDescriptionVerbose = eventDetail
//        eventDescriptionBrief = ""
//    }
//    
//    convenience init(storedEvent:StoredEvent) {
//        self.init(event:(storedEvent.eventTitle, storedEvent.eventID), organization: (storedEvent.organizationTitle, storedEvent.organizationID), facility: (storedEvent.organizationTitle, storedEvent.organizationID), eventStart: storedEvent.eventDate, durationInMinutes: storedEvent.durationMinutes, eventDetail: "")
//    }
//
//}
