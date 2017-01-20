//
//  Repository.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/8/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


typealias RepositoryUpdateCompletionHandlerType = (_ success: Bool) -> Void

enum RepositoryState : Int {
    case Current = 0, Outdated = 1, Invalid = 2, Empty = 3
}

struct UpdateProfile {
    var lastUpdated = Date(timeIntervalSinceNow: 0)
    var haveRecords = false
}



class Repository: NSObject {
    
    var repositoryAvailable = false
    var completionClosure: RepositoryUpdateCompletionHandlerType? = nil
    
    override init() {
        // ?
        super.init()
    }
    
    func asyncLoad (completion: @escaping RepositoryUpdateCompletionHandlerType) {
        self.completionClosure = completion
        
        let repoStartupState = self.checkRepositoryState()
        
        switch repoStartupState {
        case .Current:
            let _ = 3       // do nothing
        case .Outdated:
            let _ = 3       // do nothing here - after accessor is done, then update will be called
        case .Invalid:
            self.loadLocalStoreFromRemote()
        case .Empty:
            self.loadLocalStoreFromRemote()
        }
    }

    
    func load() {
        // scaffolding
            self.repositoryAvailable = true
            self.loadLocalStoreFromRemote()
    }
    
    func backgroundUpdate() {
        let repoCurrentState = self.checkRepositoryState()
        
        switch repoCurrentState {
        case .Current:
            let _ = 3       // do nothing
        case .Outdated:
            self.loadLocalStoreFromRemote()
        case .Invalid:
            self.loadLocalStoreFromRemote()
        case .Empty:
            self.loadLocalStoreFromRemote()
        }
    }
    
    
    // MARK: - methods to override
    
    internal func checkRepositoryState() -> RepositoryState {
        precondition(false, "must override this method - do not call super")
        return RepositoryState.Invalid
    }
    
    internal func loadLocalStoreFromRemote() {
        precondition(false, "must override this method - do not call super")
    }
    
    internal func clearLocalStore() {
        precondition(false, "must override this method - do not call super")
    }
    

    // MARK: - Utilities

}

// MARK: - Backendless

func initializeRemoteDatabase() {
    let APP_ID = "A9F4E1E9-EE0E-C611-FF91-4B3E52A79900"     // SwiftNeed
    let SECRET_KEY = "91933CE7-53FE-117C-FFC0-E9A8751F9800"
    let VERSION_NUM = "v1"
    
    let backendless = Backendless.sharedInstance()
    
    backendless?.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
    
}


