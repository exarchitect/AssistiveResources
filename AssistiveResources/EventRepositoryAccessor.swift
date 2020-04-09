//
//  EventRepositoryAccessor.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift


class EventRepositoryAccessor: RepositoryAccessor {
    
    private var events: [StoredEvent] = []
    
    var count: Int {
        return events.count
    }
    
    subscript(pos: Int) -> StoredEvent {
        return events[pos]
    }
    
    func requestData(filteredBy: IndividualNeedProfile){
        guard let repoAvailable = repo?.localRepositoryAvailable, repoAvailable == true else {
            state = .notLoaded
            return
        }
        retrieve(usingFilter: filteredBy)
        state = .loaded
    }
    
    override func repositoryUpdateNotification() {
        let needProfile = IndividualNeedProfile(age: 1, mobility: .noLimitation, delay: .notSpecified, primarydx: .notSpecified, secondarydx: .notSpecified)
        retrieve(usingFilter: needProfile)
        delegate?.notifyRepositoryWasUpdated()
    }
    
    
    // MARK: - PRIVATE

    private func retrieve(usingFilter: IndividualNeedProfile) {
        
        do {
            let uiRealm = try Realm()
            let eventsFound = uiRealm.objects(StoredEvent.self)
            for evt in eventsFound {
                addEvent(event: evt)
            }
            state = .loaded
            
        } catch let error as NSError {
            // handle error

            let _ = error
            state = .notLoaded
        }
        
    }
    
    private func addEvent(event: StoredEvent) {
        let eventdesc = EventDescriptor(name: event.eventTitle, identifier: event.eventID)
        let organization = OrganizationDescriptor(name: event.organizationTitle, identifier: event.organizationID)
        let facility = FacilityDescriptor(name: event.facilityTitle, identifier: event.facilityID)
        let newEvent = StoredEvent(event: eventdesc, organization: organization, facility: facility, eventStart: event.eventDate, durationInMinutes: event.durationMinutes, eventDetail: event.eventDescriptionBrief)
        events.append(newEvent)
    }
    
}



