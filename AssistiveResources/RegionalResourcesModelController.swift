//
//  RegionalResourcesModelController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift


class RegionalResourcesModelController: ModelController {
    
    private var regionalRepository : RegionalResourcesRepository!

    var organizations : OrganizationRepositoryAccessor!
    var events : EventRepositoryAccessor!
    
    init(atLocation: LocationProfile)
    {
        super.init()
        
        self.regionalRepository = RegionalResourcesRepository(location: atLocation)
        self.organizations = OrganizationRepositoryAccessor(repository: self.regionalRepository)
        self.events = EventRepositoryAccessor(repository: self.regionalRepository)
    }
    
    func initiateLoading() {

        self.regionalRepository.loadAsync { (success) in
            if (success) {
                self.events.retrieve(usingFilter: NeedsProfile(mobility: .AnyLimitation, delay: .AnyDelay, dx: .AnyDiagnosis))
                requestEventListRefresh()
                
                self.organizations.retrieve(usingFilter: NeedsProfile(mobility: .AnyLimitation, delay: .AnyDelay, dx: .AnyDiagnosis))
                requestOrgListRefresh()
            } else {
                print("loading failed")
            }
        }
    }

    func checkRepositoryUpdate() {
        self.regionalRepository.backgroundUpdate()
    }
}

