//
//  ResourcesModelController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift

class ResourcesModelController: NSObject {
    
    var organizations : OrganizationRepository!
    var events : EventRepository!

//    var defaultRealmPath:String!

    override init()
    {
        super.init()
        
//        self.setupDatabasePath()
        organizations = OrganizationRepository()
        events = EventRepository()
    }
    
    func initiateLoading() {
        // if local data available
            // if local data is for current location
                // load local
                // start remote update
                // when remote load complete refresh local
            // else
                // delete local data
                // load data from remote
                // when remote load complete refresh local
        // else (no local database)
            // load data from remote
            // when remote load complete refresh local

        self.loadTestResources()
        
    }
    
    private func loadTestResources() {
        self.events.loadTestData()
        self.organizations.loadTestData()
    }
    
    private func loadLocalResources() {
        self.events.loadLocalData()
        self.organizations.loadLocalData()
    }
    
    private func loadRemoteResources() {
        
    }
    
    // MARK: - Realm

//    func haveResourcesLoaded(forZipcode: String) -> Bool {
//        let realm = try! Realm()
//        let results = realm.object(ofType: <#T##T.Type#>, forPrimaryKey: <#T##K#>)
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

