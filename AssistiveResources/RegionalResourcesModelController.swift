//
//  RegionalResourcesModelController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift


protocol RegionalResourcesProvider {
    var regionalResourcesModelController: RegionalResourcesModelController! { get }
}


class RegionalResourcesModelController: ModelController {
    
    private var regionalRepository : RegionalResourcesRepository!
    private var online : Bool!
    
    init(atLocation: LocationProfile, isOnline: Bool)
    {
        super.init()
        
        self.online = isOnline
        self.regionalRepository = RegionalResourcesRepository(location: atLocation)
    }
    
    func initiateLoading() {

        self.regionalRepository.load { (success) in
            if (success) {
                // data pulled by accessors
            } else {
                print("loading failed")
            }
        }
    }

    func createEventAccessor(delegate: RepositoryAccessorProtocol) -> EventRepositoryAccessor {
        
        return EventRepositoryAccessor(repository: self.regionalRepository, delegate: delegate)
    }
    
    func createOrganizationAccessor(delegate: RepositoryAccessorProtocol) -> OrganizationRepositoryAccessor {
        
        return OrganizationRepositoryAccessor(repository: self.regionalRepository, delegate: delegate)
    }
    
    func checkRepositoryUpdate() {
        self.regionalRepository.backgroundUpdate()
    }
}

