//
//  AuthenticationProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class AuthenticationProcessController: ProcessController, LoginViewControllerCompletionProtocol {
    
//    typealias ExternalDependencies = UserProvider
//    
//    private let dependencies: ExternalDependencies
//
//    init(responseDelegate: ProcessControllerResponseProtocol, navigationController: UINavigationController, services: SharedServices) {
//        self.dependencies = dependencies
//        super.init(responseDelegate: responseDelegate, navController: navigationController, services: services)
//    }
        
//    override func createViewController() -> UIViewController? {
//        var loginViewController: LoginViewController
//
//        loginViewController = instantiateViewController(storyboardName: "AuthenticationProcess", storyboardID: "LoginStoryboardID") as! LoginViewController
//        loginViewController.configuration(userModelController: self.sharedServices.userModelController, completionProtocol: self)
//
//        return loginViewController
//    }
//
    override func createViewController() -> UIViewController? {
        let loginViewController: LoginViewController? = instantiateTypedViewController(storyboardName: "AuthenticationProcess", storyboardID: "LoginStoryboardID")
        loginViewController?.configuration(userModelController: self.sharedServices.userModelController, completionProtocol: self)
        
        return loginViewController
    }
    
    override func terminate () {
        super.terminate()

        requestMainNavigationRefresh()
    }
    

    // LoginViewControllerCompletionProtocol
    
    func loginAction (username: String, password: String) {

        self.sharedServices.userModelController.storeUserCredentials(username: username, password: password)

        self.sharedServices.userModelController.authorizeUser(completion: { (loginResult) in
         
            switch loginResult {
                
            case .Anonymous:
                print("Anonymous")
                fallthrough
                
            case .ServiceOffline:
                print("Service Offline")
                self.responseDelegate.requestAction(command: AssistiveCommand(type: .userLoginServiceOffline))
                self.responseDelegate.requestAction(command: AssistiveCommand(type: .dismissTopProcessController))

            case .Authenticated:
                print("authenticated")
                self.responseDelegate.requestAction(command: AssistiveCommand(type: .userLoginSuccessful))
                self.responseDelegate.requestAction(command: AssistiveCommand(type: .dismissTopProcessController))

            case .Uninitialized:
                fallthrough
                
            case .NoCredentials:
                fallthrough
                
            case .Rejected:
                print("NOT logged in")
                // TODO - warn user of bad credentials
                
            }
        })
    }
    
    
    //MARK: debug
    deinit {
        print("deallocating AuthenticationProcessController")
    }
    
}
