//
//  ResourcesModelController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

class ResourcesModelController: NSObject {
    
    private var organizations: [Organization] = []
    var organizationCount: Int {
        return organizations.count
    }
    private var events: [PublicEvent] = []
    var eventCount: Int {
        return organizations.count
    }
    
    
    override init()
    {
        super.init()
        
        //        organizationRepo = OrganizationRepository()
        //        eventRepo = EventRepository()
    }
    

    subscript(pos: Int) -> Organization {
        return organizations[pos]
    }
    
    subscript(pos: Int) -> PublicEvent {
        return events[pos]
    }
    

    func loadResources() {
        self.loadLocalResources()
        self.loadRemoteResources()
    }
    
    private func loadLocalResources() {
        self.dummyOrganizations()
        self.dummyEvents()
    }
    
    private func loadRemoteResources() {
        
    }
    
    private func dummyOrganizations() {
        // Founded in 1989 by Anthony K. Shriver, Best Buddies is a vibrant international organization that has grown from one original chapter at Georgetown University to almost 1,900 chapters worldwide, positively impacting the lives of over 900,000 people with and without IDD.  Best Buddies programs engage participants in each of the 50 United States, and in over 50 countries around the world.
        
        organizations.append(Organization(entity: ("Best Buddies International",0,0), tagline: "Friendship, Jobs and Leadership Development", mission: "We are the world's largest organization dedicated to ending the social, physical and economic isolation of the 200 million people with intellectual and developmental disabilities (IDD).", target: "People with intellectual and developmental disabilities", structure: OrganizationalStructure.MainOfficeWithChapters, scope: GeographicScope.National, location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
        organizations[0].addChapter(chapter: ("Best Buddies Kentucky",0,0), parentOrganization: ("Best Buddies International",0,0), location: LocationProfile(latitude: 0.0,longitude: 0.0,city: "Louisville",state: "KY",zip: ""))
        organizations[0].addChapter(chapter: ("Best Buddies Indiana",0,0), parentOrganization: ("Best Buddies International",0,0), location: LocationProfile(latitude: 0.0,longitude: 0.0,city: "Indianapolis",state: "IN",zip: ""))
        organizations[0].addService(title: "Integrated Employment", descrip: "", target: "")
        organizations[0].addService(title: "Friendships", descrip: "", target: "")
        organizations[0].addService(title: "Leadership Development", descrip: "", target: "")
        
        organizations.append(Organization(entity: ("Easter Seals",0,0), tagline: "", mission: "", target: "", structure: OrganizationalStructure.MainOfficeWithChapters, scope: GeographicScope.National, location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
        
        organizations.append(Organization(entity: ("United Way",0,0), tagline: "", mission: "", target: "", structure: OrganizationalStructure.MainOfficeWithChapters, scope: GeographicScope.National, location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    }

    private func dummyEvents() {
        events.append(PublicEvent(event: ("Best Buddies Spring Gala",0,0),
                                  organization: ("Best Buddies",0,0),
                                  facility: ("Grand Ballroom, Pacific Hotel",0,0),
                                  eventDate: dateFromMoDyYr(dateString: "05-10-2016"),
                                  eventStartHour: 20,
                                  eventStartMin: 30,
                                  durationMin: 210,
                                  eventDetail: "Come to the event of the season - our spring gala celebration.  This is a grand opportunity to socialize and make friends, party, and generally have a great time."))
        
        events.append(PublicEvent(event: ("Challenger Baseball Field of Dreams",1,1),
                                  organization: ("Athletes In Action",0,0),
                                  facility: ("Atherton High School, 222 Dundee Rd.",0,0),
                                  eventDate: dateFromMoDyYr(dateString: "06-11-2016"),
                                  eventStartHour: 11,
                                  eventStartMin: 30,
                                  durationMin: 120,
                                  eventDetail: "Come join us Saturday after lunch for fun on the baseball diamond. If you like to play ball, get ready for a good time. Bring a glove, or just show up ready to play.  It's time to PLAY BALL!"))
        
        events.append(PublicEvent(event: ("Special Olympics",1,1),
                                  organization: ("Athletes In Action",0,0),
                                  facility: ("Freedom Hall",0,0),
                                  eventDate: dateFromMoDyYr(dateString: "07-12-2016"),
                                  eventStartHour: 12,
                                  eventStartMin: 0,
                                  durationMin: 0,
                                  eventDetail: "The 74th annual Special Olympics will be held this coming June here in Louisville Ky, at historic Freedom Hall. Tickets will go on sale 4 weeks before the event - don't miss it!"))
    }
    
}


func initializeRemoteDatabase() {
    let APP_ID = "A9F4E1E9-EE0E-C611-FF91-4B3E52A79900"     // SwiftNeed
    let SECRET_KEY = "91933CE7-53FE-117C-FFC0-E9A8751F9800"
    let VERSION_NUM = "v1"

    let backendless = Backendless.sharedInstance()

    backendless?.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
    
}

