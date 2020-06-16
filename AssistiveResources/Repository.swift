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
    
    var available = false
    var dataUpdateCompletion: RepositoryUpdateCompletionHandlerType?
    
    func load (completion: @escaping RepositoryUpdateCompletionHandlerType) {
        dataUpdateCompletion = completion
        
        let repoStartupState = self.checkRepositoryState()
        
        switch repoStartupState {
            
        case .current:
            available = true
            dataUpdateCompletion?(true)
            dataUpdateCompletion = nil

        case .outdated:
            available = true
            dataUpdateCompletion?(true)
            dataUpdateCompletion = nil

        case .invalidLocation:
            initiateRemoteLoading()
            
        case .empty:
            initiateRemoteLoading()
        }
    }

    func backgroundUpdate() {
        let repoCurrentState = self.checkRepositoryState()
        
        switch repoCurrentState {
        case .current:
            break
        case .outdated:
            initiateRemoteLoading()
        case .invalidLocation:
            initiateRemoteLoading()
        case .empty:
            initiateRemoteLoading()
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
        self.available = false
    }
    
    internal func endRepositoryUpdate() {
        self.available = true
        
        let notificationkey = self.repositoryUpdateNotificationKey()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationkey), object: nil)
    }

}

