//
//  Repository.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/8/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


typealias RepositoryUpdateCompletionHandlerType = () -> Void

enum RepositoryAvailability : Int {
    case NotAvailable = 0, Available = 1, Loading = 2, NeedsReload = 3
}

enum LocalStoreState : Int {
    case NoStore = 0, Current = 1, OutOfDateUsable = 2, OutOfDateUnusable = 3, Updating = 4, EmptyStore = 5
}

class Repository: NSObject {
    
    var loadingState = RepositoryAvailability.NotAvailable
    var internalStoreState = LocalStoreState.NoStore
    
    override init() {
        // ?
        super.init()
    }
    
    func load() {
        // scaffolding
        if (true) {
            self.loadingState = RepositoryAvailability.Available
            self.internalStoreState = LocalStoreState.Current
            self.loadLocalStoreFromRemote()
        } else {
        
            self.internalStoreState = self.determineLocalStoreState()
            
            self.updateStoreForInternalState()
        }
    }
    
    func update() {
        
        precondition(!(self.internalStoreState == LocalStoreState.NoStore), "error - repo.update called when no store exists")
        guard !(self.internalStoreState == LocalStoreState.Updating) else {
            print ("error - repo.update called when store is updating")
            return
        }

        self.internalStoreState = self.checkIfLocalStoreIsCurrent()
        
        self.updateStoreForInternalState()
    }
    
    
    // MARK: - methods to override
    
    internal func createLocalStore() {

        self.internalStoreState = LocalStoreState.EmptyStore

        // must override and call super
    }
    
    internal func loadLocalStoreFromRemote() {
        
        self.internalStoreState = LocalStoreState.Updating
        loadingState = RepositoryAvailability.Loading
        
        // subclass to initiate load
        // must override and call super
    }
    
    internal func determineLocalStoreState()-> LocalStoreState {
        precondition(false, "must override this method - do not call super")
        return LocalStoreState.Current
    }
    
    internal func checkIfLocalStoreIsCurrent()-> LocalStoreState {
        precondition(false, "must override this method - do not call super")
        // ONLY CHECK FOR LocalStoreState.OutOfDateUsable and LocalStoreState.OutOfDateUsable
        return LocalStoreState.Current
    }
    
    internal func clearLocalStore() {
        precondition(false, "must override this method - do not call super")
    }
    
    internal func updateLocalStore() {
        precondition(false, "must override this method - do not call super")
    }
  

    // MARK: - Utilities

    private func updateStoreForInternalState() {
        
        switch self.internalStoreState {
            
        case LocalStoreState.NoStore:
            self.loadingState = RepositoryAvailability.NotAvailable
            self.createLocalStore()
            self.updateLocalStore()
            
        case LocalStoreState.Current:
            self.loadingState = RepositoryAvailability.Available
            
        case LocalStoreState.OutOfDateUsable:
            self.updateLocalStore()
            
        case LocalStoreState.OutOfDateUnusable:
            self.updateLocalStore()
            
        case LocalStoreState.Updating:
            // do not execute code if update in progress
            self.loadingState = RepositoryAvailability.Loading  // redundant
            
        case LocalStoreState.EmptyStore:
            self.updateLocalStore()
            
        }
    }
}

// MARK: - Backendless

func initializeRemoteDatabase() {
    let APP_ID = "A9F4E1E9-EE0E-C611-FF91-4B3E52A79900"     // SwiftNeed
    let SECRET_KEY = "91933CE7-53FE-117C-FFC0-E9A8751F9800"
    let VERSION_NUM = "v1"
    
    let backendless = Backendless.sharedInstance()
    
    backendless?.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
    
}


