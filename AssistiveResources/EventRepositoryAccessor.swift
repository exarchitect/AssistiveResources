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
    
    func requestData(filteredBy: NeedsProfile){
        if (self.repo.repositoryAvailable) {
            self.retrieve(usingFilter: filteredBy)
            self.state = .Loaded
        } else {
            self.state = .NotLoaded
            // when we get an update from the repository, we will retrieve the data and call the delegate
        }
    }
    
    override func repositoryUpdateNotification() {
        self.retrieve(usingFilter: NeedsProfile(mobility: .AnyLimitation, delay: .AnyDelay, dx: .AnyDiagnosis))
        self.delegate?.notifyRepositoryWasUpdated()
    }
    
    
    // MARK: - PRIVATE

    private func retrieve(usingFilter: NeedsProfile) {
        
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


// MARK: - TESTING

func testEvents() -> [StoredEvent] {
    var returnevents: [StoredEvent] = []
    
    returnevents.append(StoredEvent(event: ("Best Buddies Spring Gala",0),
                              organization: ("Best Buddies",0),
                              facility: ("Grand Ballroom, Pacific Hotel",0),
                              eventStart: Date.dateFromComponents(yr:2016, mo:5, dy:10, hr:10, min:0)!,
                              durationInMinutes: 120,
                              eventDetail: "Come to the event of the season - our spring gala celebration.  This is a grand opportunity to socialize and make friends, party, and generally have a great time."))
    
    returnevents.append(StoredEvent(event: ("Challenger Baseball Field of Dreams",1),
                              organization: ("Athletes In Action",0),
                              facility: ("Atherton High School, 222 Dundee Rd.",0),
                              eventStart: Date.dateFromComponents(yr:2016, mo:5, dy:12, hr:11, min:30)!,
                              durationInMinutes: 120,
                              eventDetail: "Come join us Saturday after lunch for fun on the baseball diamond. If you like to play ball, get ready for a good time. Bring a glove, or just show up ready to play.  It's time to PLAY BALL!"))
    
    returnevents.append(StoredEvent(event: ("Penguin Project \"Crazy For You\"",1),
                              organization: ("Penguin Project",0),
                              facility: ("Peoria Heights High School, 1422 River Rd.",0),
                              eventStart: Date.dateFromComponents(yr:2016, mo:5, dy:12, hr:19, min:00)!,
                              durationInMinutes: 180,
                              eventDetail: "Come join us for an evening of mayhem, misadventure and mistaken identity.  A classic musical performed by our local youth. Prepare to be amazed and amused."))
    
    returnevents.append(StoredEvent(event: ("Special Olympics",1),
                                    organization: ("Athletes In Action",0),
                                    facility: ("Freedom Hall",0),
                                    eventStart: Date.dateFromComponents(yr:2016, mo:5, dy:15, hr:12, min:0)!,
                                    durationInMinutes: 0,
                                    eventDetail: "The 74th annual Special Olympics will be held this coming June here in Louisville Ky, at historic Freedom Hall. Tickets will go on sale 4 weeks before the event - don't miss it!"))
    
    returnevents.append(StoredEvent(event: ("Easter Seals Open House",1),
                                    organization: ("Easter Seals of Central Illinois",0),
                                    facility: ("Decker Center",0),
                                    eventStart: Date.dateFromComponents(yr:2017, mo:2, dy:7, hr:10, min:0)!,
                                    durationInMinutes: 8*60,
                                    eventDetail: "Your local Easter Seals chapter is hosting an Open House with our OSF partners.  Come join us for donuts and coffee, and find out who we are and how we can help you and your family."))
    
    return returnevents
}
