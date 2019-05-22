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
    
    func requestData(filteredBy: IndividualNeedProfile){
        if (self.repo.localRepositoryAvailable) {
            self.retrieve(usingFilter: filteredBy)
            self.state = .Loaded
        } else {
            self.state = .NotLoaded
            // when we get an update for the repository, we will retrieve the data and call the delegate
        }
    }
    
    override func repositoryUpdateNotification() {
        self.retrieve(usingFilter: IndividualNeedProfile(age: 1, mobility: .noLimitation, delay: .notSpecified, primarydx: .notSpecified, secondarydx: .notSpecified))
        self.delegate?.notifyRepositoryWasUpdated()
    }

    // MARK: - PRIVATE
    
    func retrieve(usingFilter: IndividualNeedProfile) {
        
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

