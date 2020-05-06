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
        events.count
    }
    
    subscript(pos: Int) -> StoredEvent {
        events[pos]
    }
    
    func descriptor(at: Int) -> EventDescriptor {
        events[at].descriptor
    }

    func eventMatching(identifier: Int) -> StoredEvent? {
        events.first { $0.eventID == identifier }
    }

    func requestData(filteredBy: FilterDictionary){
        guard let repoAvailable = repo?.localRepositoryAvailable, repoAvailable == true else {
            state = .notLoaded
            return
        }
        retrieve(usingFilter: filteredBy)
        state = .loaded
    }
    
    override func repositoryUpdateNotification() {
        let needProfile = FilterDictionary()
        retrieve(usingFilter: needProfile)
        delegate?.notifyRepositoryWasUpdated()
    }
    
    class func retrieveEvent(withIdentifier identifier: Int) -> StoredEvent? {

        do {
            let uiRealm = try Realm()
            return uiRealm.objects(StoredEvent.self).first { $0.eventID == identifier }

        } catch {
            return nil
        }
    }

    // MARK: - PRIVATE

    private func retrieve(usingFilter individualNeedProfile: FilterDictionary) {
        
        do {
            let uiRealm = try Realm()
            let events = uiRealm.objects(StoredEvent.self)
            for event in events {
                addEvent(event)
            }
            state = .loaded
            
        } catch let error as NSError {
            // handle error

            let _ = error
            state = .notLoaded
        }
        
    }
    
    private func addEvent(_ event: StoredEvent) {
        let eventdesc = EventDescriptor(name: event.eventTitle, identifier: event.eventID)
        let organization = OrganizationDescriptor(name: event.organizationTitle, identifier: event.organizationID)
        let facility = FacilityDescriptor(name: event.facilityTitle, identifier: event.facilityID)
        let newEvent = StoredEvent(event: eventdesc, organization: organization, facility: facility, eventStart: event.eventDate, durationInMinutes: event.durationMinutes, eventDetail: event.eventDescriptionBrief)
        events.append(newEvent)
    }
    
}



