//
//  EventRepository.swift
//  SwiftNeed
//
//  Created by Bill Johnson on 5/16/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

class EventRepository: NSObject {
    
    private var events: [PublicEvent] = []
    var count: Int {
        return events.count
    }
    
    override init() {
        super.init()
        // ?
    }
    
    subscript(pos: Int) -> PublicEvent {
        return events[pos]
    }
    
    func loadLocalData() {

    }
    
    func loadTestData() {
        self.dummyEvents()
    }
    
    private func loadRemoteData() {
        
    }
    

    private func dummyEvents() {
        events.append(PublicEvent(event: ("Best Buddies Spring Gala",EntityType.Event,0),
                                  organization: ("Best Buddies",EntityType.Organization,0),
                                  facility: ("Grand Ballroom, Pacific Hotel",EntityType.Facility,0),
                                  eventDate: DateTimeDuration(yr:2016, mo:5, dy:10, hr:10, min:0, durationMin:120),
                                  eventDetail: "Come to the event of the season - our spring gala celebration.  This is a grand opportunity to socialize and make friends, party, and generally have a great time."))
        
        events.append(PublicEvent(event: ("Challenger Baseball Field of Dreams",EntityType.Event,1),
                                  organization: ("Athletes In Action",EntityType.Organization,0),
                                  facility: ("Atherton High School, 222 Dundee Rd.",EntityType.Facility,0),
                                  eventDate: DateTimeDuration(yr:2016, mo:5, dy:12, hr:11, min:30, durationMin:120),
                                  eventDetail: "Come join us Saturday after lunch for fun on the baseball diamond. If you like to play ball, get ready for a good time. Bring a glove, or just show up ready to play.  It's time to PLAY BALL!"))
        
        events.append(PublicEvent(event: ("Special Olympics",EntityType.Event,1),
                                  organization: ("Athletes In Action",EntityType.Organization,0),
                                  facility: ("Freedom Hall",EntityType.Facility,0),
                                  eventDate: DateTimeDuration(yr:2016, mo:5, dy:15, hr:12, min:0, durationMin:0),
                                  eventDetail: "The 74th annual Special Olympics will be held this coming June here in Louisville Ky, at historic Freedom Hall. Tickets will go on sale 4 weeks before the event - don't miss it!"))
    }
}
