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


enum RepositoryState : Int {
    case Current = 0, Outdated = 1, Invalid = 2, Empty = 3
}



class Repository: NSObject {
    
    var repositoryAvailable = false
    var completionClosure: RepositoryUpdateCompletionHandlerType? = nil
    
    override init() {
        // ?
        super.init()
    }
    
    func load (completion: @escaping RepositoryUpdateCompletionHandlerType) {
        self.completionClosure = completion
        
        let repoStartupState = self.checkRepositoryState()
        
        switch repoStartupState {
            
        case .Current:
            self.completionClosure?(true)
            self.completionClosure = nil
            self.repositoryAvailable = true
            
        case .Outdated:      // do nothing here - after accessor is done, then update will be called
            self.completionClosure?(true)
            self.completionClosure = nil
            self.repositoryAvailable = true

        case .Invalid:
            self.loadLocalStoreFromRemote()
            
        case .Empty:
            self.loadLocalStoreFromRemote()
        }
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
        fatalError("override \(#function)")
    }
    
    internal func loadLocalStoreFromRemote() {
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
        self.repositoryAvailable = false
    }
    
    internal func endRepositoryUpdate() {
        self.repositoryAvailable = true
        
        let notificationkey = self.repositoryUpdateNotificationKey()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationkey), object: nil)
    }

}

// MARK: - Backendless

func initializeRemoteDatabase() {
    let APP_ID = "F817A756-BEB2-79AD-FF65-D49A4E97A800"     // AssistiveResources
    let SECRET_KEY = "6F155BAE-91A6-0455-FFFD-30F4442B0A00"
    //let VERSION_NUM = "v1"
    
    let backendless = Backendless.sharedInstance()
    
    //backendless?.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
    backendless?.initApp(APP_ID, apiKey: SECRET_KEY)
    
}

//func initializeRemoteDatabase() {
//    let APP_ID = "A9F4E1E9-EE0E-C611-FF91-4B3E52A79900"     // SwiftNeed
//    let SECRET_KEY = "91933CE7-53FE-117C-FFC0-E9A8751F9800"
//    let VERSION_NUM = "v1"
//    
//    let backendless = Backendless.sharedInstance()
//    
//    //backendless?.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
//    backendless?.initApp(APP_ID, apiKey: SECRET_KEY)
//    
//}

