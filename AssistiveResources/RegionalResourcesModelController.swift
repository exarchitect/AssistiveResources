//
//  RegionalResourcesModelController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift



class RegionalResourcesModelController: NSObject {
    
    private var regionalRepository : RegionalResourcesRepository?
    private var online : Bool!
    
    init(atLocation: LocationProfile, isOnline: Bool)
    {
        super.init()
        
        self.online = isOnline
        self.regionalRepository = RegionalResourcesRepository(location: atLocation)
    }
    
    func initiateLoading() {
        regionalRepository?.load { success in
            guard success == true else {
                print("loading failed")
                return
            }
            // data pulled by accessors, using notification mechanism
        }
    }

    func createEventAccessor(delegate: RepositoryAccessorProtocol) -> EventRepositoryAccessor? {
        guard let repo = regionalRepository else {
            return nil
        }
        return EventRepositoryAccessor(repository: repo, delegate: delegate)
    }
    
    func createOrganizationAccessor(delegate: RepositoryAccessorProtocol) -> OrganizationRepositoryAccessor? {
        guard let repo = regionalRepository else {
            return nil
        }
        return OrganizationRepositoryAccessor(repository: repo, delegate: delegate)
    }
    
    func checkRepositoryUpdate() {
        regionalRepository?.backgroundUpdate()
    }
}

