//
//  PublicEvent.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift


struct EntityFilter {
    var needProfile: ProvidedServicesProfile?
    var proximityRadius: Int = -1
    var entityDescriptor: ResourceEntityDescriptor
}

class StoredEvent: Object {
    @objc dynamic var objectId: String?
    @objc dynamic var created: Date?
    @objc dynamic var updated: Date?

    @objc dynamic var eventTitle: String = ""
    @objc dynamic var eventID: Int = 0
    @objc dynamic var organizationTitle: String = ""
    @objc dynamic var organizationID: Int = 0
    @objc dynamic var facilityTitle: String!
    @objc dynamic var facilityID: Int = 0
    @objc dynamic var eventDate: Date!
    @objc dynamic var durationMinutes: Int = 0
    @objc dynamic var eventDescriptionBrief: String = ""

    var timeBlock: TimeBlockDescriptor?

    convenience required init(event: EventDescriptor, organization: OrganizationDescriptor, facility: FacilityDescriptor, eventStart: Date, durationInMinutes: Int, eventDetail: String)
    {
        self.init()
        
        self.eventTitle = event.name
        self.organizationTitle = organization.name
        self.facilityTitle = facility.name
        self.eventDate = eventStart
        self.durationMinutes = durationInMinutes

        self.eventDescriptionBrief = eventDetail

        self.timeBlock = TimeBlockDescriptor(date: eventDate, durationMin: durationInMinutes)

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


