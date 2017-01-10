//
//  OrganizationRepositoryAccessor.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

class OrganizationRepositoryAccessor: NSObject {
    
    private var repo: Repository
    private var organizations: [Organization] = []
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
    }
    
    private func dummyOrganizations() {
        // Founded in 1989 by Anthony K. Shriver, Best Buddies is a vibrant international organization that has grown from one original chapter at Georgetown University to almost 1,900 chapters worldwide, positively impacting the lives of over 900,000 people with and without IDD.  Best Buddies programs engage participants in each of the 50 United States, and in over 50 countries around the world.
        
        organizations.append(Organization(entity: ("Best Buddies International",EntityType.Organization,0), tagline: "Friendship, Jobs and Leadership Development", mission: "We are the world's largest organization dedicated to ending the social, physical and economic isolation of the 200 million people with intellectual and developmental disabilities (IDD).", target: "People with intellectual and developmental disabilities", structure: OrganizationalStructure.MainOfficeWithChapters, scope: GeographicScope.National, location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
        
        organizations.append(Organization(entity: ("Easter Seals",EntityType.Organization,0), tagline: "", mission: "", target: "", structure: OrganizationalStructure.MainOfficeWithChapters, scope: GeographicScope.National, location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
        
        organizations.append(Organization(entity: ("United Way",EntityType.Organization,0), tagline: "", mission: "", target: "", structure: OrganizationalStructure.MainOfficeWithChapters, scope: GeographicScope.National, location:LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: ""), url: ""))
    }

}
