//
//  RegionalResourcesRemoteDatasource.swift
//  AssistiveResources
//
//  Created by WCJ on 2/4/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import UIKit
import Timepiece

class RegionalResourcesRemoteDatasource: NSObject, RemoteDatasourceProtocol {
    
//    var eventList: [StoredEvent]! = nil
//    var orgList: [Organization]! = nil
    var isRetrievingData: Bool = false

    func validateConnection() {
        let _ = 3
    }
    
    func pull(completion: @escaping RemoteDataRetrievalCompletionType) {

        self.isRetrievingData = true
        
        // GET THE DATA
        
//        // TEST
//        self.eventList = testEvents()
//
//        // TEST
//        self.orgList = testOrganizations()
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 4.0)) {
            self.isRetrievingData = false
            completion(true)
        }
    }
    
    func getEvents() -> [StoredEvent] {
        return testEvents()
    }
    
    func getOrganizations() -> [Organization] {
        return testOrganizations()
    }
    
//    func releaseRemote () {
//        self.eventList = nil;
//        self.orgList = nil;
//    }
}


// MARK: - Remote database - Backendless

func initializeRemoteDatabase() {
    let APP_ID = "F817A756-BEB2-79AD-FF65-D49A4E97A800"     // AssistiveResources
    let SECRET_KEY = "6F155BAE-91A6-0455-FFFD-30F4442B0A00"
    //let VERSION_NUM = "v1"
    
    let backendless = Backendless.sharedInstance()
    
    //backendless?.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
    backendless?.initApp(APP_ID, apiKey: SECRET_KEY)
    
}

// MARK: - TESTING

func testEvents() -> [StoredEvent] {
    var returnevents: [StoredEvent] = []
    
    returnevents.append(StoredEvent(event: ("Best Buddies Spring Gala",0),
                                    organization: ("Best Buddies",0),
                                    facility: ("Grand Ballroom, Pacific Hotel",0),
                                    eventStart: Date(year: 2016, month: 5, day: 10, hour: 10, minute: 0, second: 0), //Date.dateFromComponents(yr:2016, mo:5, dy:10, hr:10, min:0),
                                    durationInMinutes: 120,
                                    eventDetail: "Come to the event of the season - our spring gala celebration.  This is a grand opportunity to socialize and make friends, party, and generally have a great time."))
    
    returnevents.append(StoredEvent(event: ("Challenger Baseball Field of Dreams",1),
                                    organization: ("Athletes In Action",0),
                                    facility: ("Atherton High School, 222 Dundee Rd.",0),
                                    eventStart: Date(year: 2016, month: 5, day: 12, hour: 11, minute: 30, second: 0), //Date.dateFromComponents(yr:2016, mo:5, dy:12, hr:11, min:30)!,
                                    durationInMinutes: 120,
                                    eventDetail: "Come join us Saturday after lunch for fun on the baseball diamond. If you like to play ball, get ready for a good time. Bring a glove, or just show up ready to play.  It's time to PLAY BALL!"))
    
    returnevents.append(StoredEvent(event: ("Penguin Project \"Crazy For You\"",1),
                                    organization: ("Penguin Project",0),
                                    facility: ("Peoria Heights High School, 1422 River Rd.",0),
                                    eventStart: Date(year: 2016, month: 5, day: 12, hour: 19, minute: 0, second: 0), //Date.dateFromComponents(yr:2016, mo:5, dy:12, hr:19, min:00)!,
                                    durationInMinutes: 180,
                                    eventDetail: "Come join us for an evening of mayhem, misadventure and mistaken identity.  A classic musical performed by our local youth. Prepare to be amazed and amused."))
    
    returnevents.append(StoredEvent(event: ("Special Olympics",1),
                                    organization: ("Athletes In Action",0),
                                    facility: ("Freedom Hall",0),
                                    eventStart: Date(year: 2016, month: 5, day: 15, hour: 12, minute: 0, second: 0), //Date.dateFromComponents(yr:2016, mo:5, dy:15, hr:12, min:0)!,
                                    durationInMinutes: 0,
                                    eventDetail: "The 74th annual Special Olympics will be held this coming June here in Louisville Ky, at historic Freedom Hall. Tickets will go on sale 4 weeks before the event - don't miss it!"))
    
    returnevents.append(StoredEvent(event: ("Easter Seals Open House",1),
                                    organization: ("Easter Seals of Central Illinois",0),
                                    facility: ("Decker Center",0),
                                    eventStart: Date(year: 2016, month: 2, day: 7, hour: 10, minute: 0, second: 0), //Date.dateFromComponents(yr:2017, mo:2, dy:7, hr:10, min:0)!,
                                    durationInMinutes: 8*60,
                                    eventDetail: "Your local Easter Seals chapter is hosting an Open House with our OSF partners.  Come join us for donuts and coffee, and find out who we are and how we can help you and your family."))
    
    return returnevents
}


func testOrganizations() -> [Organization] {
    var returnOrganizations: [Organization] = []
    
    returnOrganizations.append(Organization(entity: ("Best Buddies International",0), tagline: "Friendship, Jobs and Leadership Development", mission: "Dedicated to ending the social, physical and economic isolation of the 200 million people with intellectual and developmental disabilities.", scope: "Best Buddies programs engage participants in each of the 50 United States, and in over 50 countries around the world", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    
    returnOrganizations.append(Organization(entity: ("Easter Seals",0), tagline: "Taking on disability together", mission: "Providing exceptional services, education, outreach, and advocacy so that people living with autism and other disabilities can live, learn, work and play in our communities.", scope: "Easter Seals is a national organization with over 75 affiliates and local service centers in the US", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    
    returnOrganizations.append(Organization(entity: ("The Penguin Project",0), tagline: "Empowering children with special needs through theater", mission: "Providing an opportunity for children with special needs to develop creative skills related to the theater arts, and participate in a community theater experience", scope: "The Penguin Project is based in central Illinois and has 18 Projects across the US in 11 different states", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    
    return returnOrganizations
}

