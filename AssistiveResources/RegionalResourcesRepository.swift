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


// MARK: - Backendless

func initializeRemoteDatabase() {
    let APP_ID = "A9F4E1E9-EE0E-C611-FF91-4B3E52A79900"     // SwiftNeed
    let SECRET_KEY = "91933CE7-53FE-117C-FFC0-E9A8751F9800"
    let VERSION_NUM = "v1"
    
    let backendless = Backendless.sharedInstance()
    
    backendless?.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
    
}

