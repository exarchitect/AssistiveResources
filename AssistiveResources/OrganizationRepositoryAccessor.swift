//
//  OrganizationRepositoryAccessor.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift


class OrganizationRepositoryAccessor: RepositoryAccessor {
    
    private var organizations: [Organization] = []
    
    var count: Int {
        return organizations.count
    }
    
    subscript(pos: Int) -> Organization {
        return organizations[pos]
    }
    
    func requestData(filteredBy: NeedsProfile){
        if (self.repo.repositoryAvailable) {
            self.retrieve(usingFilter: filteredBy)
            self.state = .Loaded
        } else {
            self.state = .NotLoaded
            // when we get an update for the repository, we will retrieve the data and call the delegate
        }
    }
    
    override func repositoryUpdateNotification() {
        self.retrieve(usingFilter: NeedsProfile(mobility: .AnyLimitation, delay: .AnyDelay, dx: .AnyDiagnosis))
        self.delegate?.notifyRepositoryWasUpdated()
    }

    // MARK: - PRIVATE
    
    func retrieve(usingFilter: NeedsProfile) {
        
        do {
            let uiRealm = try Realm()
            let orgsFound = uiRealm.objects(Organization.self)
            for org in orgsFound {
                self.addOrganization(org: org)
            }
            self.state = .Loaded
           
        } catch let error as NSError {
            // handle error
            
            let _ = error
            self.state = .NotLoaded
        }
        
    }

    func addOrganization(org: Organization) {
        let newOrg = Organization(entity: EntityDescriptor(entityName: org.organizationTitle,entityID:org.organizationID) , tagline: org.tagline, mission: org.mission, scope: org.geographicScope, location: LocationProfile(latitude: org.hqLatitude,longitude: org.hqLongitude,city: "",state: "",zip: org.hqZip), url: "")
        self.organizations.append(newOrg)
    }
    
}


// MARK: - TESTING

func testOrganizations() -> [Organization] {
    var returnOrganizations: [Organization] = []
    
    returnOrganizations.append(Organization(entity: ("Best Buddies International",0), tagline: "Friendship, Jobs and Leadership Development", mission: "Dedicated to ending the social, physical and economic isolation of the 200 million people with intellectual and developmental disabilities.", scope: "Best Buddies programs engage participants in each of the 50 United States, and in over 50 countries around the world", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    
    returnOrganizations.append(Organization(entity: ("Easter Seals",0), tagline: "Taking on disability together", mission: "Providing exceptional services, education, outreach, and advocacy so that people living with autism and other disabilities can live, learn, work and play in our communities.", scope: "Easter Seals is a national organization with over 75 affiliates and local service centers in the US", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    
    returnOrganizations.append(Organization(entity: ("The Penguin Project",0), tagline: "Empowering children with special needs through theater", mission: "Providing an opportunity for children with special needs to develop creative skills related to the theater arts, and participate in a community theater experience", scope: "The Penguin Project is based in central Illinois and has 18 Projects across the US in 11 different states", location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    
    return returnOrganizations
}

