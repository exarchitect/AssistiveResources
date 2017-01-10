//
//  RegionalResourcesRepository.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

class RegionalResourcesRepository: Repository {
    
    override init() {
        super.init()
        // ?
    }
    
    internal override func loadLocalStoreFromRemote() {
        // load from remote to local db
        // on completion...
        // notify complete
        self.loadingState = RepositoryState.Available
        
        //super.loadLocalStoreFromRemote()
    }
    
    internal override func localStorePath()-> String {
        
        return "replace this with a path to the realm db"
    }
}
