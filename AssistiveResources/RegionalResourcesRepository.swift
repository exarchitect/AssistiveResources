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
    
    internal override func loadLocalStoreFromRemote() {
        // load from remote to local db
        // on completion...
        // notify complete
        self.loadingState = RepositoryState.Available
        
        //super.loadLocalStoreFromRemote()
    }
    
    internal override func localStorePath()-> String {
        
        return "replace this with a path to the realm db"
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


