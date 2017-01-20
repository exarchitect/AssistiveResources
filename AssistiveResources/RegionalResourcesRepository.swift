//
//  RegionalResourcesRepository.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


class RegionalResourcesRepository: Repository {
    
    private var loc: LocationProfile?
    
//    override init() {
//        super.init()
//        // ?
//    }
    
    init(location: LocationProfile)
    {
        super.init()
        
        self.loc = location
    }
    
    override func checkRepositoryState() -> RepositoryState {

        var state: RepositoryState!
        
        // if (have database)
            // - if has UpdateProfile with name: "homebase", LocationProfile matches location, UpdateProfile.time has NOT expired, then:
                state = RepositoryState.Current
            // - if has UpdateProfile with name: "homebase", LocationProfile matches location, UpdateProfile.time HAS expired, then:   
                state = RepositoryState.Outdated
            // - if has UpdateProfile with name: "homebase", LocationProfile DOES NOT match location, then:   
                state = RepositoryState.Invalid
            // - if DOES NOT HAVE UpdateProfile with name: "homebase", then:   
                state = RepositoryState.Empty
        // if NO database
            // create empty database, then:
                state = RepositoryState.Empty
        
        return state
    }
    
    override func loadLocalStoreFromRemote() {
        self.clearLocalStore()
        // load from remote to local db
        // on completion...  call self.completionClosure
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 4.0)) {
            self.completionClosure?(true)
            self.completionClosure = nil

            self.repositoryAvailable = true
        }
    }
    
    override func clearLocalStore() {
        // clear contents of invalid or outdated db
    }

    
    // MARK: - Realm
    
    //    func haveResourcesLoaded(forZipcode: String) -> Bool {
    //        let realm = try! Realm()
    //        let results = realm.object(ofType: -T.Type, forPrimaryKey: -K)
    //
    //        return (results != .noErr);
    //    }
    
    //    func setupDatabasePath() {
    //        let dbName:String = "resources_v1.realm";
    //        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    //        let realmPath = documentsPath.appending(dbName)
    //
    //        var config = RLMRealmConfiguration.defaultConfiguration()
    //        config.path = realmPath
    //        RLMRealmConfiguration.setDefaultConfiguration(config)
    //    }
    
}


