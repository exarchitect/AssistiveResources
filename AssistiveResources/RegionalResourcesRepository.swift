//
//  RegionalResourcesRepository.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


class RegionalResourcesRepository: Repository {
    
    override init() {
        super.init()
        // ?
    }
    
    override func loadLocalStoreFromRemote() {
        // load from remote to local db
        // on completion...
        // notify complete
        self.loadingState = RepositoryAvailability.Available
        
        //super.loadLocalStoreFromRemote()
    }
    
    override func createLocalStore() {
        
        super.createLocalStore()
        
        // create
    }
    
    override func determineLocalStoreState()-> LocalStoreState {
        //
        return LocalStoreState.Current
    }
    
    override func checkIfLocalStoreIsCurrent()-> LocalStoreState {
        
        // ONLY CHECK FOR LocalStoreState.OutOfDateUsable and LocalStoreState.OutOfDateUsable
        return LocalStoreState.Current
    }
    
    override func clearLocalStore() {
        
        // 
        self.internalStoreState = LocalStoreState.EmptyStore
    }
    
    override func updateLocalStore() {
        
        //
        let _ = 4
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


