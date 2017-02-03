//
//  OrganizationRepositoryAccessor.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

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
    
    func retrieve(usingFilter: NeedsProfile) {
        self.dummyOrganizations()
        self.loaded = true
    }
    
    func addOrganization(org: Organization) {
        let newOrg = Organization(entity: EntityDescriptor(entityName: org.organizationTitle,entityID:org.organizationID) , tagline: org.tagline, mission: org.mission, target: org.targetPopulation, location: LocationProfile(latitude: org.hqLatitude,longitude: org.hqLongitude,city: "",state: "",zip: org.hqZip), url: "")
        self.organizations.append(newOrg)
    }
    
    private func dummyOrganizations() {
        // Founded in 1989 by Anthony K. Shriver, Best Buddies is a vibrant international organization that has grown from one original chapter at Georgetown University to almost 1,900 chapters worldwide, positively impacting the lives of over 900,000 people with and without IDD.  Best Buddies programs engage participants in each of the 50 United States, and in over 50 countries around the world.
        
        organizations.append(Organization(entity: ("Best Buddies International",0), tagline: "Friendship, Jobs and Leadership Development", mission: "We are the world's largest organization dedicated to ending the social, physical and economic isolation of the 200 million people with intellectual and developmental disabilities (IDD).", target: "People with intellectual and developmental disabilities", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
        
        organizations.append(Organization(entity: ("Easter Seals",0), tagline: "Taking on disability together", mission: "Easterseals provides exceptional services, education, outreach, and advocacy so that people living with autism and other disabilities can live, learn, work and play in our communities. ", target: "Children and adults with disabilities and their families", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
        
        organizations.append(Organization(entity: ("The Penguin Project",0), tagline: "Empowering children with special needs through theater", mission: "Provide an opportunity for children with special needs to develop creative skills related to the theater arts, and participate in a community theater experience", target: "Children with physical and developmental disabilities", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    }
    
    // RepositoryAccessorProtocol
    
    func isLoading() -> Bool {
        return !self.loaded
    }
    
}


func testOrganizations() -> [Organization] {
    var returnOrganizations: [Organization] = []
    
    returnOrganizations.append(Organization(entity: ("Best Buddies International",0), tagline: "Friendship, Jobs and Leadership Development", mission: "Dedicated to ending the social, physical and economic isolation of the 200 million people with intellectual and developmental disabilities.", target: "People with intellectual and developmental disabilities", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    
    returnOrganizations.append(Organization(entity: ("Easter Seals",0), tagline: "Taking on disability together", mission: "Providing exceptional services, education, outreach, and advocacy so that people living with autism and other disabilities can live, learn, work and play in our communities.", target: "Children and adults with disabilities and their families", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    
    returnOrganizations.append(Organization(entity: ("The Penguin Project",0), tagline: "Empowering children with special needs through theater", mission: "Providing an opportunity for children with special needs to develop creative skills related to the theater arts, and participate in a community theater experience", target: "Children with physical and developmental disabilities", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    
    return returnOrganizations
}

