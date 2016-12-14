//
//  OrganizationRepository.swift
//  SwiftNeed
//
//  Created by Bill Johnson on 5/27/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

class OrganizationRepository: NSObject {
    
    private var organizations: [Organization] = []
    var count: Int {
        return organizations.count
    }
    
    override init() {
        super.init()
        
    }
    
    subscript(pos: Int) -> Organization {
        return organizations[pos]
    }
    
    func loadData() {
        self.dummyOrganizations()
    }
    
    private func loadRemoteData() {
        
    }
    
    private func dummyOrganizations() {
        // Founded in 1989 by Anthony K. Shriver, Best Buddies is a vibrant international organization that has grown from one original chapter at Georgetown University to almost 1,900 chapters worldwide, positively impacting the lives of over 900,000 people with and without IDD.  Best Buddies programs engage participants in each of the 50 United States, and in over 50 countries around the world.
        
        organizations.append(Organization(entity: ("Best Buddies International",0,0), tagline: "Friendship, Jobs and Leadership Development", mission: "We are the world's largest organization dedicated to ending the social, physical and economic isolation of the 200 million people with intellectual and developmental disabilities (IDD).", target: "People with intellectual and developmental disabilities", structure: OrganizationalStructure.MainOfficeWithChapters, scope: GeographicScope.National, location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
//        organizations[0].addChapter(("Best Buddies Kentucky",0,0), parentOrganization: ("Best Buddies International",0,0), location: LocationProfile(latitude: 0.0,longitude: 0.0,city: "Louisville",state: "KY",zip: ""))
//        organizations[0].addChapter(("Best Buddies Indiana",0,0), parentOrganization: ("Best Buddies International",0,0), location: LocationProfile(latitude: 0.0,longitude: 0.0,city: "Indianapolis",state: "IN",zip: ""))
//        organizations[0].addService("Integrated Employment", descrip: "", target: "")
//        organizations[0].addService("Friendships", descrip: "", target: "")
//        organizations[0].addService("Leadership Development", descrip: "", target: "")
        
        organizations.append(Organization(entity: ("Easter Seals",0,0), tagline: "", mission: "", target: "", structure: OrganizationalStructure.MainOfficeWithChapters, scope: GeographicScope.National, location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
        
        organizations.append(Organization(entity: ("United Way",0,0), tagline: "", mission: "", target: "", structure: OrganizationalStructure.MainOfficeWithChapters, scope: GeographicScope.National, location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    }
}
