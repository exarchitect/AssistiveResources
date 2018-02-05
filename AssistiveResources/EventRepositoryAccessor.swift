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
        if (self.repo.localRepositoryAvailable) {
            self.retrieve(usingFilter: filteredBy)
            self.state = .Loaded
        } else {
            self.state = .NotLoaded
            // when we get an update from the repository, we will retrieve the data and call the delegate
        }
    }
    
    override func repositoryUpdateNotification() {
        self.retrieve(usingFilter: IndividualNeedProfile(age: 1, mobility: .NoLimitation, delay: .NoDevelopmentalAgeSpecified, primarydx: .NoDiagnosisSpecified, secondarydx: .NoDiagnosisSpecified))
        self.delegate?.notifyRepositoryWasUpdated()
    }
    
    
    // MARK: - PRIVATE

    private func retrieve(usingFilter: IndividualNeedProfile) {
        
        do {
            let uiRealm = try Realm()
            let eventsFound = uiRealm.objects(StoredEvent.self)
            for evt in eventsFound {
                self.addEvent(event: evt)
            }
            self.state = .Loaded
            
        } catch let error as NSError {
            // handle error

            let _ = error
            self.state = .NotLoaded
        }
        
    }
    
    private func addEvent(event: StoredEvent) {
        let newEvent = StoredEvent(event: EntityDescriptor(entityName: event.eventTitle, entityID:event.eventID), organization: EntityDescriptor(entityName: event.organizationTitle, entityID:event.organizationID), facility: EntityDescriptor(entityName: event.facilityTitle, entityID:event.facilityID), eventStart: event.eventDate, durationInMinutes: event.durationMinutes, eventDetail: event.eventDescriptionBrief)
        events.append(newEvent)
    }
    
}



