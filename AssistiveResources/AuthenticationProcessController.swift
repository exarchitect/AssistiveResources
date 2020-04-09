//
//  AuthenticationProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

protocol AuthenticationProtocol: class {
    func userEnteredCredentials (loginType: UserAccess, credentials: Credentials)
}

class AuthenticationProcessController: ProcessController, AuthenticationProtocol {
    
    override func createPrimaryViewController() -> ProcessViewController? {
        return instantiateProcessViewController(storyboardName: "AuthenticationProcess", storyboardID: "LoginStoryboardID")
    }

    // MARK:- AuthenticationCoordinatorProtocol
    
    func userEnteredCredentials (loginType: UserAccess, credentials: Credentials) {

        sharedServices.userModel.validateCredentials(completion: { loginResult in
            switch loginResult {
            case .authenticated:
                //print("authenticated")
                self.sharedServices.userModel.storeUserCredentials(username: credentials.userName, password: credentials.password)
                self.executeCommand(.userSuccessfullyIdentified)
                self.executeCommand(.dismissCurrentProcess)
            case .needCredentials:
                // TODO - get credentials
                fallthrough
            case .unknown:
                print("NOT logged in")
                // TODO - warn user of bad credentials
            }
        })
    }
    
    
    //MARK:- debug
    
    deinit {
        let _ = 0
        //print("deallocating AuthenticationProcessController")
    }
    
}
