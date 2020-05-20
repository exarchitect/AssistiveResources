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
    
    private var organizationCache: [Organization]?
    
    var count: Int {
        organizationCache?.count ?? 0
    }

    subscript(pos: Int) -> Organization? {
        organizationCache?[pos]
    }

    func descriptor(at: Int) -> OrganizationDescriptor? {
        organizationCache?[at].descriptor
    }

    func organizationsMatching(identifier: Int) -> Organization? {
        organizationCache?.first { $0.organizationID == identifier }
    }

    override func haveLocalData() -> Bool {
        organizationCache != nil
    }

    override func repositoryUpdateNotification() {
        let needProfile = FilterDictionary()
        updateLocalCache(using: needProfile)
        delegate?.notifyRepositoryWasUpdated()
    }

    class func cachedOrganization(withIdentifier identifier: Int) -> Organization? {

        do {
            let uiRealm = try Realm()
            return uiRealm.objects(Organization.self).first { $0.organizationID == identifier }
        } catch {
            return nil
        }
    }

    // MARK: - PRIVATE
    
    override func updateLocalCache(using filter: FilterDictionary) {

        organizationCache = []
        do {
            let uiRealm = try Realm()
            let organizations = uiRealm.objects(Organization.self)
            for organization in organizations {
                addOrganization(organization)
            }

        } catch let error as NSError {
            // handle error

            let _ = error
        }
    }

    func addOrganization(_ org: Organization) {
        guard organizationCache != nil else {
            return
        }
        let newOrg = Organization(entity: OrganizationDescriptor(name: org.organizationTitle, identifier: org.organizationID), tagline: org.tagline, mission: org.mission, scope: org.geographicScope, location: LocationProfile(latitude: org.hqLatitude,longitude: org.hqLongitude,city: "",state: "",zip: org.hqZip), url: "")
        organizationCache!.append(newOrg)
    }
    
}

