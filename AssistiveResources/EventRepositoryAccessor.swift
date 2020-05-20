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

    private var eventCache: [StoredEvent]?

    var count: Int {
        eventCache?.count ?? 0
    }

    subscript(pos: Int) -> StoredEvent? {
        eventCache?[pos]
    }

    func descriptor(at: Int) -> EventDescriptor? {
        eventCache?[at].descriptor
    }

    func eventMatching(identifier: Int) -> StoredEvent? {
        eventCache?.first { $0.eventID == identifier }
    }

    override func haveLocalData() -> Bool {
        eventCache != nil
    }

    override func repositoryUpdateNotification() {
        let needProfile = FilterDictionary()
        updateLocalCache(using: needProfile)
        delegate?.notifyRepositoryWasUpdated()
    }

    class func cachedEvent(withIdentifier identifier: Int) -> StoredEvent? {

        do {
            let uiRealm = try Realm()
            return uiRealm.objects(StoredEvent.self).first { $0.eventID == identifier }

        } catch {
            return nil
        }
    }

    // MARK: - PRIVATE

    override func updateLocalCache(using filter: FilterDictionary) {

        eventCache = []
        do {
            let uiRealm = try Realm()
            let events = uiRealm.objects(StoredEvent.self)
            for event in events {
                addEvent(event)
            }

        } catch let error as NSError {
            // handle error

            let _ = error
        }
        
    }
    
    private func addEvent(_ event: StoredEvent) {
        guard eventCache != nil else {
            return
        }
        let eventdesc = EventDescriptor(name: event.eventTitle, identifier: event.eventID)
        let organization = OrganizationDescriptor(name: event.organizationTitle, identifier: event.organizationID)
        let facility = FacilityDescriptor(name: event.facilityTitle, identifier: event.facilityID)
        let newEvent = StoredEvent(event: eventdesc, organization: organization, facility: facility, eventStart: event.eventDate, durationInMinutes: event.durationMinutes, eventDetail: event.eventDescriptionBrief)
        eventCache!.append(newEvent)
    }
    
}



