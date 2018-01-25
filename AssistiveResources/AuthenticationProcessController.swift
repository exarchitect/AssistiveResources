//
//  AuthenticationProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class AuthenticationProcessController: ProcessController, LoginViewControllerCompletionProtocol {
    
    override func createPrimaryViewController() -> ProcessViewController? {
        let loginViewController: LoginViewController? = instantiateViewController(storyboardName: "AuthenticationProcess", storyboardID: "LoginStoryboardID")
        loginViewController?.configuration(userModelController: self.sharedServices.userModelController, completionProtocol: self)
        
        return loginViewController
    }
    
    override func terminate () {
        super.terminate()

        requestMainNavigationRefresh()
    }
    

    // MARK:- LoginViewControllerCompletionProtocol
    
    func loginAction (username: String, password: String) {

        self.sharedServices.userModelController.storeUserCredentials(username: username, password: password)

        self.sharedServices.userModelController.authorizeUser(completion: { (loginResult) in
         
            switch loginResult {
                
            case .Anonymous:
                print("Anonymous")
                fallthrough
                
            case .ServiceOffline:
                print("Service Offline")
                fallthrough

            case .Authenticated:
                print("authenticated")
                self.requestAction(command: AssistiveCommand(type: .userIdentified))
                self.requestAction(command: AssistiveCommand(type: .dismissProcessController))

            case .Uninitialized:
                // TODO - get credentials
                fallthrough
                
            case .NoCredentials:
                // TODO - get credentials
                fallthrough
                
            case .Rejected:
                print("NOT logged in")
                // TODO - warn user of bad credentials
                
            }
        })
    }
    
    
    //MARK:- debug
    
    deinit {
        print("deallocating AuthenticationProcessController")
    }
    
}
