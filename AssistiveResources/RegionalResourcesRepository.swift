//
//  RegionalResourcesRepository.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift


class RegionalResourcesRepository: LocalRepository {
    var available = false
    var dataUpdateCompletion: RepositoryUpdateCompletionHandlerType?

    private var location: LocationProfile?
    private var remoteDataSource = RegionalResourcesRemoteDatasource()

    var retrievingData: Bool {
        get {
            return remoteDataSource.isRetrievingData
        }
    }

    init(location: LocationProfile)
    {
        self.location = location
    }

    func repositoryStateUpdate() -> RepositoryState {

        do {
            let realmDB = try Realm()
            return internalRepositoryStateUpdate(db: realmDB)
        } catch let error as NSError {
            // handle error
            // TODO - if try fails, then the db format has changed - invalidate the database & delete
            let _ = error

            return RepositoryState.empty
        }
    }

    func initiateRemoteLoading() {

        guard self.retrievingData == false else {
            return
        }
        remoteDataSource.validateConnection()
        remoteDataSource.pull { success in
            
            if success {
                self.beginRepositoryUpdate()
                self.clearLocalStore()

                // update local store
                let eventList = self.remoteDataSource.getEvents()
                eventList.forEach { $0.save() }

                let organizationList = self.remoteDataSource.getOrganizations()
                organizationList.forEach { $0.save() }

                self.dataUpdateCompletion?(true)
                self.dataUpdateCompletion = nil
                
                self.endRepositoryUpdate()
            } else {
                // TODO: failure case
            }
        }
    }

    func clearLocalStore() {
        // TODO clear contents of invalid or outdated db
    }

    private func internalRepositoryStateUpdate(db: Realm) -> RepositoryState {
        let repoProfiles = db.objects(RepositoryProfile.self)

        guard repoProfiles.isEmpty == false else {
            // create empty database
            let dbProfile = RepositoryProfile()
            dbProfile.save()
            return RepositoryState.empty
        }

        let profile = repoProfiles[0]
        let locationMatch: Bool = (profile.location == self.location?.zipCode)
        let expireDate = profile.lastUpdated.addingTimeInterval(TimeInterval(kExpirationSeconds))
        let now = Date()
        let dateCompare = now.compare(expireDate)
        let staleLocalStore = (dateCompare == ComparisonResult.orderedDescending)

        guard locationMatch == true else {
            return RepositoryState.invalidLocation
        }
        if staleLocalStore == true {
            return RepositoryState.outdated
        } else {
            return RepositoryState.current
        }
    }

    func repositoryUpdateNotificationKey () -> String {
        "key_notify_resource_repository_changed"
    }

    // Realm
        
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


