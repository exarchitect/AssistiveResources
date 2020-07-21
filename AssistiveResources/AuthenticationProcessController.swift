//
//  AuthenticationProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

protocol AuthenticationHandler: class {
    func userEnteredCredentials(_ credentials: Credentials)
    func userSignupRequest(credentials: Credentials, location: LocationProfile)
    func userGuestAccessRequest(location: LocationProfile)
}

class AuthenticationProcessController: ProcessController, AuthenticationHandler {
    
    override func createPrimaryViewController() -> UIViewController? {
        let primaryViewController = instantiateProcessViewController(storyboardName: "AuthenticationProcess", storyboardID: "LoginStoryboardID")
        primaryViewController?.parentProcessController = self
        return primaryViewController
    }

    // MARK:- AuthenticationHandler
    
    func userEnteredCredentials (_ credentials: Credentials) {
        sharedServices.userModel.validateCredentials(completion: { loginResult in
            switch loginResult {
            case .authenticated:
                //print("authenticated")
                self.sharedServices.userModel.storeUserCredentials(username: credentials.userName, password: credentials.password)
                self.commandHandler.execute(command: .userSuccessfullyIdentified)
                self.commandHandler.execute(command: .dismissCurrentProcess)
            case .needCredentials:
                // TODO - get credentials
                fallthrough
            case .unknown:
                print("NOT logged in")
                // TODO - warn user of bad credentials
            }
        })
    }

    func userSignupRequest(credentials: Credentials, location: LocationProfile) {
        // TODO - implement
        userEnteredCredentials (credentials)
    }

    func userGuestAccessRequest(location: LocationProfile) {
        // TODO - ?
        print("guest access")
        self.commandHandler.execute(command: .userSuccessfullyIdentified)
        self.commandHandler.execute(command: .dismissCurrentProcess)
    }

    //MARK:- debug
    
    deinit {
        let _ = 0
        print("deallocating AuthenticationProcessController")
    }
    
}
