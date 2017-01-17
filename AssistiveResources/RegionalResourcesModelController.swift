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
    
    override init()
    {
        super.init()
        
        self.regionalRepository = RegionalResourcesRepository()
        self.organizations = OrganizationRepositoryAccessor(repository: self.regionalRepository)
        self.events = EventRepositoryAccessor(repository: self.regionalRepository)
    }
    
    func initiateLoading() {
        self.regionalRepository.load()
        // on completion
            self.events.retrieve(usingFilter: NeedsProfile(mobility: MobilityLimitation.NoLimitation, delay: DevelopmentalDelay.NoDelay, dx: Diagnosis.NoDiagnosis))
            self.organizations.retrieve(usingFilter: NeedsProfile(mobility: MobilityLimitation.NoLimitation, delay: DevelopmentalDelay.NoDelay, dx: Diagnosis.NoDiagnosis))
    }

    func checkRepositoryUpdate() {
        self.regionalRepository.update()
    }
}

