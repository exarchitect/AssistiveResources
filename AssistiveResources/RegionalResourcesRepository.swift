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
    
    private var location: LocationProfile?
    private var remoteDataSource = RegionalResourcesRemoteDatasource()

    var retrievingData: Bool {
        get {
            return remoteDataSource.isRetrievingData
        }
    }

    init(location: LocationProfile)
    {
        super.init()
        
        self.location = location
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
        
        guard self.retrievingData == false else {
            return
        }
        remoteDataSource.validateConnection()
        remoteDataSource.pull { success in
            
            if success {
                self.beginRepositoryUpdate()
                self.clearLocalStore()

                // update local store
                let eventList: [StoredEvent] = self.remoteDataSource.getEvents()
                for evt in eventList {
                    evt.save()
                }
                
                let orgList: [Organization] = self.remoteDataSource.getOrganizations()
                for org in orgList {
                    org.save()
                }

                self.dataUpdateCompletion?(true)
                self.dataUpdateCompletion = nil
                
                self.endRepositoryUpdate()
            } else {
                // TODO: failure case
            }
        }
    }
    
    override func clearLocalStore() {
        // TODO clear contents of invalid or outdated db
    }

    
    private func repositoryState(db: Realm) -> RepositoryState {
        
        var state: RepositoryState!
        var haveLocalDatabase = false
        
        let profilesFound = db.objects(RepositoryProfile.self)
        haveLocalDatabase = !profilesFound.isEmpty
        
        if (haveLocalDatabase) {
            
            let profile = profilesFound[0]
            let locationMatch: Bool = (profile.location == self.location?.zipCode)
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
            
        } else {        // NO profiles found, so we assume no database
            
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


