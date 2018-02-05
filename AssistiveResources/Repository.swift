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


enum RepositoryState : Int {
    case Current = 0, Outdated = 1, Invalid = 2, Empty = 3
}

protocol RemoteDatasourceProtocol: class {
    func validateConnection ()
    func pull (completion: @escaping RemoteDataRetrievalCompletionType)
}


class Repository: NSObject {
    
    var localRepositoryAvailable = false
    var dataUpdateCompletion: RepositoryUpdateCompletionHandlerType? = nil
    
    override init() {
        // ?
        super.init()
    }
    
    func load (completion: @escaping RepositoryUpdateCompletionHandlerType) {
        self.dataUpdateCompletion = completion
        
        let repoStartupState = self.checkRepositoryState()
        
        switch repoStartupState {
            
        case .Current:
            self.dataUpdateCompletion?(true)
            self.dataUpdateCompletion = nil
            self.localRepositoryAvailable = true
            
        case .Outdated:      // do nothing here? - after accessor is done, then update will be called
            self.dataUpdateCompletion?(true)
            self.dataUpdateCompletion = nil
            self.localRepositoryAvailable = true

        case .Invalid:
            self.initiateRemoteLoading()
            
        case .Empty:
            self.initiateRemoteLoading()
        }
    }

    func backgroundUpdate() {
        let repoCurrentState = self.checkRepositoryState()
        
        switch repoCurrentState {
        case .Current:
            let _ = 3       // do nothing
        case .Outdated:
            self.initiateRemoteLoading()
        case .Invalid:
            self.initiateRemoteLoading()
        case .Empty:
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

