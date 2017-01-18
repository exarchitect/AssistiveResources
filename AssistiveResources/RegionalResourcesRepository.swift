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
    
    override func establishLocalStore() -> RepositoryState {

        // check db existance, create if needed
        
        // ck internals, see if current or outdated
        
        // set flags
        self.repositoryAvailable = false
        self.repositoryCurrent = false
        
        return RepositoryState.Empty        // ?
    }
    
    override func loadLocalStoreFromRemote() {
        // load from remote to local db
        // on completion...
        // notify complete
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 1.1)) {
            self.completionClosure?(true)
            self.completionClosure = nil

            self.repositoryAvailable = true
            self.repositoryCurrent = true
        }
    }
    
    override func checkRepositoryState() -> RepositoryState {
        
        // check out of date (outdated)
        // check location (invalid)
        
        return RepositoryState.Invalid
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


