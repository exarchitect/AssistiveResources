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
        guard let repoAvailable = repo?.localRepositoryAvailable, repoAvailable == true else {
            state = .notLoaded
            return
        }
        retrieve(usingFilter: filteredBy)
        state = .loaded
    }
    
    override func repositoryUpdateNotification() {
        retrieve(usingFilter: IndividualNeedProfile(age: 1, mobility: .noLimitation, delay: .notSpecified, primarydx: .notSpecified, secondarydx: .notSpecified))
        delegate?.notifyRepositoryWasUpdated()
    }

    // MARK: - PRIVATE
    
    func retrieve(usingFilter: IndividualNeedProfile) {
        
        do {
            let uiRealm = try Realm()
            let orgsFound = uiRealm.objects(Organization.self)
            for org in orgsFound {
                addOrganization(org: org)
            }
            state = .loaded
           
        } catch let error as NSError {
            // handle error
            
            let _ = error
            state = .notLoaded
        }
        
    }

    func addOrganization(org: Organization) {
        let newOrg = Organization(entity: OrganizationDescriptor(name: org.organizationTitle, identifier: org.organizationID), tagline: org.tagline, mission: org.mission, scope: org.geographicScope, location: LocationProfile(latitude: org.hqLatitude,longitude: org.hqLongitude,city: "",state: "",zip: org.hqZip), url: "")
        organizations.append(newOrg)
    }
    
}

