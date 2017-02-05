//
//  OrganizationRepositoryAccessor.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift


class OrganizationRepositoryAccessor: NSObject, RepositoryAccessorProtocol {
    
    weak private var repo: Repository?
    private var organizations: [Organization] = []
    var loaded: Bool = false
    
    var count: Int {
        return organizations.count
    }
    
    init (repository: Repository) {
        
        self.repo = repository
    }
    
    subscript(pos: Int) -> Organization {
        return organizations[pos]
    }
    
//    func retrieve(usingFilter: NeedsProfile) {
//        self.dummyOrganizations()
//        self.loaded = true
//    }

    func retrieve(usingFilter: NeedsProfile) {
        
        do {
            let uiRealm = try Realm()
            let orgsFound = uiRealm.objects(Organization.self)
            for org in orgsFound {
                self.addOrganization(org: org)
            }
            self.loaded = true
            
        } catch let error as NSError {
            // handle error
            
            let _ = error
            self.loaded = false
        }
        
    }

    func addOrganization(org: Organization) {
        let newOrg = Organization(entity: EntityDescriptor(entityName: org.organizationTitle,entityID:org.organizationID) , tagline: org.tagline, mission: org.mission, scope: org.geographicScope, location: LocationProfile(latitude: org.hqLatitude,longitude: org.hqLongitude,city: "",state: "",zip: org.hqZip), url: "")
        self.organizations.append(newOrg)
    }
    
    private func dummyOrganizations() {
        
        organizations.append(Organization(entity: ("Best Buddies International",0), tagline: "Friendship, Jobs and Leadership Development", mission: "We are the world's largest organization dedicated to ending the social, physical and economic isolation of the 200 million people with intellectual and developmental disabilities (IDD).", scope: "Best Buddies programs engage participants in each of the 50 United States, and in over 50 countries around the world", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
        
        organizations.append(Organization(entity: ("Easter Seals",0), tagline: "Taking on disability together", mission: "Easterseals provides exceptional services, education, outreach, and advocacy so that people living with autism and other disabilities can live, learn, work and play in our communities. ", scope: "Easter Seals is a national organization with over 75 affiliates and local service centers in the US", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
        
        organizations.append(Organization(entity: ("The Penguin Project",0), tagline: "Empowering children with special needs through theater", mission: "Provide an opportunity for children with special needs to develop creative skills related to the theater arts, and participate in a community theater experience", scope: "The Penguin Project has 18 Projects across the US in 11 different states", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    }
    
    // RepositoryAccessorProtocol
    
    func isLoading() -> Bool {
        return !self.loaded
    }
    
}


func testOrganizations() -> [Organization] {
    var returnOrganizations: [Organization] = []
    
    returnOrganizations.append(Organization(entity: ("Best Buddies International",0), tagline: "Friendship, Jobs and Leadership Development", mission: "Dedicated to ending the social, physical and economic isolation of the 200 million people with intellectual and developmental disabilities.", scope: "Best Buddies programs engage participants in each of the 50 United States, and in over 50 countries around the world", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    
    returnOrganizations.append(Organization(entity: ("Easter Seals",0), tagline: "Taking on disability together", mission: "Providing exceptional services, education, outreach, and advocacy so that people living with autism and other disabilities can live, learn, work and play in our communities.", scope: "Easter Seals is a national organization with over 75 affiliates and local service centers in the US", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    
    returnOrganizations.append(Organization(entity: ("The Penguin Project",0), tagline: "Empowering children with special needs through theater", mission: "Providing an opportunity for children with special needs to develop creative skills related to the theater arts, and participate in a community theater experience", scope: "The Penguin Project has 18 Projects across the US in 11 different states", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    
    return returnOrganizations
}

