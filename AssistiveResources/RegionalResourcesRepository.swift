//
//  RegionalResourcesRepository.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift


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

        do {
            let realmDB = try Realm()
            return self.repositoryState(db: realmDB)
        } catch let error as NSError {
            // handle error
            // TODO - if try fails, then the db format has changed - invalidate the database & delete
            let _ = error

            return RepositoryState.Empty
        }
    }
    
//    func old_checkRepositoryState() -> RepositoryState {
//        
//        var state: RepositoryState!
//        var haveLocalDatabase = false
//        
//        let uiRealm = try! Realm()
//        let profilesFound = uiRealm.objects(RepositoryProfile.self)
//        haveLocalDatabase = !profilesFound.isEmpty
//        
//        if (haveLocalDatabase) {
//            
//            let profile = profilesFound[0]
//            let locationMatch: Bool = (profile.location == self.loc?.zipCode)
//            let expireDate = profile.lastUpdated.addingTimeInterval(TimeInterval(kExpirationSeconds))
//            let now = Date()
//            let dateCompare = now.compare(expireDate)
//            let expired: Bool = (dateCompare == ComparisonResult.orderedDescending)
//            
//            if (locationMatch && !expired) {
//                state = RepositoryState.Current
//                
//            } else if (locationMatch && expired) {
//                state = RepositoryState.Outdated
//                
//            } else if (!locationMatch) {
//                state = RepositoryState.Invalid
//            }
//            
//            // - if DOES NOT HAVE UpdateProfile then:
//            //    state = RepositoryState.Empty
//            
//        } else {        // if NO database
//            // create empty database
//            
//            let dbProfile = RepositoryProfile()
//            dbProfile.save()
//            
//            state = RepositoryState.Empty
//        }
//        
//        return state
//    }
    
    override func loadLocalStoreFromRemote() {
        self.clearLocalStore()
        // load from remote to local db
        // on completion...  call self.completionClosure
        
        // TEMP
        let eventList: [StoredEvent] = testEvents()
        for evt in eventList {
            evt.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 4.0)) {
            self.completionClosure?(true)
            self.completionClosure = nil

            self.repositoryAvailable = true
        }
    }
    
    override func clearLocalStore() {
        // clear contents of invalid or outdated db
    }

    
    private func repositoryState(db: Realm) -> RepositoryState {
        
        var state: RepositoryState!
        var haveLocalDatabase = false
        
        let profilesFound = db.objects(RepositoryProfile.self)
        haveLocalDatabase = !profilesFound.isEmpty
        
        if (haveLocalDatabase) {
            
            let profile = profilesFound[0]
            let locationMatch: Bool = (profile.location == self.loc?.zipCode)
            let expireDate = profile.lastUpdated.addingTimeInterval(TimeInterval(kExpirationSeconds))
            let now = Date()
            let dateCompare = now.compare(expireDate)
            let expired: Bool = (dateCompare == ComparisonResult.orderedDescending)
            
            if (locationMatch && !expired) {
                state = RepositoryState.Current
                
            } else if (locationMatch && expired) {
                state = RepositoryState.Outdated
                
            } else if (!locationMatch) {
                state = RepositoryState.Invalid
            }
            
            // - if DOES NOT HAVE UpdateProfile then:
            //    state = RepositoryState.Empty
            
        } else {        // if NO database
            // create empty database
            
            let dbProfile = RepositoryProfile()
            dbProfile.save()
            
            state = RepositoryState.Empty
        }
        
        return state
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


