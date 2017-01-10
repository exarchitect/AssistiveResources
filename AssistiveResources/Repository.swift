//
//  Repository.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/8/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


typealias RepositoryUpdateCompletionHandlerType = () -> Void

enum RepositoryState : Int {
    case Unknown = 0, Available = 1, Loading = 2, OutOfDate = 3
}

class Repository: NSObject {
    
    var loadingState = RepositoryState.Unknown
    private var haveLocalStore = false
    
    override init() {
        // ?
        super.init()
    }
    
    func load() {
        // scaffolding
        self.loadingState = RepositoryState.Available
        self.loadLocalStoreFromRemote()
        
        precondition(!self.haveLocalStore, "load called when repo.haveLocalStore set to true")
        // if have local store?   @self.localStorePath()
            // self.updateRepository()
        // if no local store
            // self.createAndLoadLocalStore()
        self.haveLocalStore = true
    }
    
    func updateRepository() {
        
        precondition(self.haveLocalStore, "updateRepository called when repo.haveLocalStore set to false")
        // if local store location is current
            // is local store last update current (within 1 hour)
                // if yes, set RepositoryState.Available
                // if no
                    // set RepositoryState.OutOfDate
                    // clear out local store   @self.localStorePath()
                    // loadLocalStoreFromRemote()
        // if local store location NOT current
            // clear out local store   @self.localStorePath()
            // loadLocalStoreFromRemote()
    }
    
    internal func createAndLoadLocalStore() {
        
        // create local store   @self.localStorePath()
        // call self.loadLocalStoreFromRemote()
    }
    
    internal func loadLocalStoreFromRemote() {
        
        // subclass to initiate load
        
        loadingState = RepositoryState.Loading
    }
    
    internal func localStorePath()-> String {
        
        return ""
    }
    
}
