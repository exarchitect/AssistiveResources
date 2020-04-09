//
//  Repository.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/8/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


let kExpirationSeconds = 60 * 60 * 24       // 24 hours


typealias RepositoryUpdateCompletionHandlerType = (_ success: Bool) -> Void
typealias RemoteDataRetrievalCompletionType = (_ success: Bool) -> Void


enum RepositoryState {
    case current, outdated, invalidLocation, empty
}

protocol RemoteDatasourceProtocol: class {
    func validateConnection ()
    func pull (completion: @escaping RemoteDataRetrievalCompletionType)
}


class Repository: NSObject {
    
    var localRepositoryAvailable = false
    var dataUpdateCompletion: RepositoryUpdateCompletionHandlerType? = nil
    
    func load (completion: @escaping RepositoryUpdateCompletionHandlerType) {
        self.dataUpdateCompletion = completion
        
        let repoStartupState = self.checkRepositoryState()
        
        switch repoStartupState {
            
        case .current:
            self.localRepositoryAvailable = true
            self.dataUpdateCompletion?(true)
            self.dataUpdateCompletion = nil

        case .outdated:      // do nothing here? - after accessor is done, then update will be called
            self.localRepositoryAvailable = true
            self.dataUpdateCompletion?(true)
            self.dataUpdateCompletion = nil

        case .invalidLocation:
            self.initiateRemoteLoading()
            
        case .empty:
            self.initiateRemoteLoading()
        }
    }

    func backgroundUpdate() {
        let repoCurrentState = self.checkRepositoryState()
        
        switch repoCurrentState {
        case .current:
            let _ = 3       // do nothing
        case .outdated:
            self.initiateRemoteLoading()
        case .invalidLocation:
            self.initiateRemoteLoading()
        case .empty:
            self.initiateRemoteLoading()
        }
    }
    
    
    // MARK: - methods to override
    
    internal func checkRepositoryState() -> RepositoryState {
        fatalError("override \(#function)")
    }
    
    internal func initiateRemoteLoading() {
        fatalError("override \(#function)")
    }
    
    internal func clearLocalStore() {
        fatalError("override \(#function)")
    }
    
    internal func repositoryUpdateNotificationKey () -> String {
        fatalError("override \(#function)")
    }
    

    // MARK: - methods for subclass use
    
    internal func beginRepositoryUpdate() {
        self.localRepositoryAvailable = false
    }
    
    internal func endRepositoryUpdate() {
        self.localRepositoryAvailable = true
        
        let notificationkey = self.repositoryUpdateNotificationKey()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationkey), object: nil)
    }

}

