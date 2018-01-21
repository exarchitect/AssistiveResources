//
//  AuthenticationProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class AuthenticationProcessController: ProcessController, LoginViewControllerCompletionProtocol {
    
    typealias ExternalDependencies = UserProvider
    
    private let dependencies: ExternalDependencies

    init(responseDelegate: ProcessControllerResponseProtocol, navigationController: UINavigationController, dependencies: ExternalDependencies) {
        self.dependencies = dependencies
        super.init(responseDelegate: responseDelegate, navController: navigationController)
    }
    
//    override func launch() {
//        var loginViewController: LoginViewController
//        
//        loginViewController = instantiateViewController(storyboardName: "AuthenticationProcess", storyboardID: "LoginStoryboardID") as! LoginViewController
//        loginViewController.configuration(userModelController: self.dependencies.userModelController, completionProtocol: self)
//        
//        self.primaryViewController = loginViewController
//        super.launch()
//    }
    
    override func createViewController() -> UIViewController {
        var loginViewController: LoginViewController
        
        loginViewController = instantiateViewController(storyboardName: "AuthenticationProcess", storyboardID: "LoginStoryboardID") as! LoginViewController
        loginViewController.configuration(userModelController: self.dependencies.userModelController, completionProtocol: self)
        
        return loginViewController
    }
    
    override func terminate () {
        super.terminate()

        requestMainNavigationRefresh()
    }
    

    // LoginViewControllerCompletionProtocol
    
    func loginAction (username: String, password: String) {

        self.dependencies.userModelController.storeUserCredentials(username: username, password: password)

        self.dependencies.userModelController.authorizeUser(completion: { (loginResult) in
         
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
