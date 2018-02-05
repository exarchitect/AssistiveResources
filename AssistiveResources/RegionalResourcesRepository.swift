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
    private var remoteDataSrc: RegionalResourcesRemoteDatasource! = nil
    private var retrievingData: Bool = false

    init(location: LocationProfile)
    {
        super.init()
        
        self.loc = location
        self.remoteDataSrc = RegionalResourcesRemoteDatasource()
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
    

    override func initiateRemoteLoading() {
        // 1) create RemoteDatasource if it doesnt exist
        // 2) call remoteData.pull and pass closure
        // 3) return
        // 4) when closure called:
        //  - beginRepoUpdate
        //  - update realm store (clear and save)
        //  - release remoteData object
        //  - endRepoUpdate
        //  - call closure / clear closure
        
        guard self.retrievingData == false else {
            return
        }
        self.retrievingData = true

        if self.remoteDataSrc == nil {
            self.remoteDataSrc = RegionalResourcesRemoteDatasource()
        }
        
        self.remoteDataSrc.validateConnection()
        
        self.remoteDataSrc.pull { (success) in
            
            if success {
                self.beginRepositoryUpdate()
                self.clearLocalStore()

                // update local store
                let eventList: [StoredEvent] = self.remoteDataSrc.getEvents()
                for evt in eventList {
                    evt.save()
                }
                
                let orgList: [Organization] = self.remoteDataSrc.getOrganizations()
                for org in orgList {
                    org.save()
                }

                self.dataUpdateCompletion?(true)
                self.dataUpdateCompletion = nil
                self.retrievingData = false
                
                self.endRepositoryUpdate()
            } else {
                // TODO: failure case
            }
        }
    }
    
//    func initiateRemoteLoading_original() {
//    //override func initiateRemoteLoading() {
//
//        self.beginRepositoryUpdate()
//        self.clearLocalStore()
//        
//        // TEMP
//        let eventList: [StoredEvent] = testEvents()
//        for evt in eventList {
//            evt.save()
//        }
//        
//        // TEMP
//        let orgList: [Organization] = testOrganizations()
//        for org in orgList {
//            org.save()
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 4.0)) {
//            self.dataUpdateCompletion?(true)
//            self.dataUpdateCompletion = nil
//
//            self.endRepositoryUpdate()
//        }
//    }
    
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
    
    override func repositoryUpdateNotificationKey () -> String {
        return "key_notify_resource_repository_changed"
    }
    


    // MARK: - Realm
        
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


