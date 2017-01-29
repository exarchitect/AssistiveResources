//
//  EventRepositoryAccessor.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

class EventRepositoryAccessor: NSObject, RepositoryAccessorProtocol {
    
    weak private var repo: Repository?
    private var events: [StoredEvent] = []
    private var loaded: Bool = false
    
    var count: Int {
        return events.count
    }
    
    init (repository: Repository) {
        
        self.repo = repository
    }
    
    subscript(pos: Int) -> StoredEvent {
        return events[pos]
    }
    
    func retrieve(usingFilter: NeedsProfile) {
        self.dummyEvents()
        self.loaded = true
    }
    
    private func dummyEvents() {
        events.append(StoredEvent(event: ("Best Buddies Spring Gala",0),
                                  organization: ("Best Buddies",0),
                                  facility: ("Grand Ballroom, Pacific Hotel",0),
                                  eventStart: Date.dateFromComponents(yr:2016, mo:5, dy:10, hr:10, min:0)!,
                                  durationInMinutes: 120,
                                  eventDetail: "Come to the event of the season - our spring gala celebration.  This is a grand opportunity to socialize and make friends, party, and generally have a great time."))
        
        events.append(StoredEvent(event: ("Challenger Baseball Field of Dreams",1),
                                  organization: ("Athletes In Action",0),
                                  facility: ("Atherton High School, 222 Dundee Rd.",0),
                                  eventStart: Date.dateFromComponents(yr:2016, mo:5, dy:12, hr:11, min:30)!,
                                  durationInMinutes: 120,
                                  eventDetail: "Come join us Saturday after lunch for fun on the baseball diamond. If you like to play ball, get ready for a good time. Bring a glove, or just show up ready to play.  It's time to PLAY BALL!"))
        
        events.append(StoredEvent(event: ("Penguin Project \"Crazy For You\"",1),
                                  organization: ("Penguin Project",0),
                                  facility: ("Peoria Heights High School, 1422 River Rd.",0),
                                  eventStart: Date.dateFromComponents(yr:2016, mo:5, dy:12, hr:19, min:00)!,
                                  durationInMinutes: 180,
                                  eventDetail: "Come join us for an evening of mayhem, misadventure and mistaken identity.  A classic musical performed by our local youth. Prepare to be amazed and amused."))
        
        events.append(StoredEvent(event: ("Special Olympics",1),
                                  organization: ("Athletes In Action",0),
                                  facility: ("Freedom Hall",0),
                                  eventStart: Date.dateFromComponents(yr:2016, mo:5, dy:15, hr:12, min:0)!,
                                  durationInMinutes: 0,
                                  eventDetail: "The 74th annual Special Olympics will be held this coming June here in Louisville Ky, at historic Freedom Hall. Tickets will go on sale 4 weeks before the event - don't miss it!"))
    }

    // RepositoryAccessorProtocol
    
    func isLoading() -> Bool {
        return !self.loaded
    }
    
}
