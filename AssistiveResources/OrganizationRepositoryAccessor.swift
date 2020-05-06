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
        organizations.count
    }
    
    subscript(pos: Int) -> Organization {
        organizations[pos]
    }

    func descriptor(at: Int) -> OrganizationDescriptor {
        return organizations[at].descriptor
    }

    func eventMatching(identifier: Int) -> Organization? {
        organizations.first { $0.organizationID == identifier }
    }

    func requestData(filteredBy: FilterDictionary){
        guard let repoAvailable = repo?.localRepositoryAvailable, repoAvailable == true else {
            state = .notLoaded
            return
        }
        retrieve(usingFilter: filteredBy)
        state = .loaded
    }
    
    override func repositoryUpdateNotification() {
        let needProfile = FilterDictionary()
        retrieve(usingFilter: needProfile)
        delegate?.notifyRepositoryWasUpdated()
    }

    class func retrieveOrganization(withIdentifier identifier: Int) -> Organization? {

        do {
            let uiRealm = try Realm()
            return uiRealm.objects(Organization.self).first { $0.organizationID == identifier }

        } catch {
            return nil
        }
    }

    // MARK: - PRIVATE
    
    func retrieve(usingFilter individualNeedProfile: FilterDictionary) {
        
        do {
            let uiRealm = try Realm()
            let organizations = uiRealm.objects(Organization.self)
            for organization in organizations {
                addOrganization(organization)
            }
            state = .loaded
           
        } catch let error as NSError {
            // handle error
            
            let _ = error
            state = .notLoaded
        }
        
    }

    func addOrganization(_ org: Organization) {
        let newOrg = Organization(entity: OrganizationDescriptor(name: org.organizationTitle, identifier: org.organizationID), tagline: org.tagline, mission: org.mission, scope: org.geographicScope, location: LocationProfile(latitude: org.hqLatitude,longitude: org.hqLongitude,city: "",state: "",zip: org.hqZip), url: "")
        organizations.append(newOrg)
    }
    
}

