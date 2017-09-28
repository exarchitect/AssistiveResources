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
    private var loginViewController: LoginViewController!

    init(responseDelegate: ProcessControllerResponseHandler, dependencies: ExternalDependencies) {
        self.dependencies = dependencies
        super.init(responseDelegate: responseDelegate)
    }
    
    override func launch(navController: UINavigationController) -> Bool {
        
        let authenticationStoryboard: UIStoryboard? = UIStoryboard(name: "AuthenticationProcess", bundle: nil)
        self.loginViewController = authenticationStoryboard?.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
        self.loginViewController.configuration(userModelController: self.dependencies.userModelController, completionProtocol: self)
        
//        let parentViewController = self.responseDelegate.navigationController().topViewController
        let parentViewController = navController.topViewController
        parentViewController?.present(self.loginViewController, animated: true, completion: nil)

        return (authenticationStoryboard != nil && self.loginViewController != nil)
    }
    
    override func terminate (navController: UINavigationController) {
        super.terminate(navController: navController)

//        let parentViewController = self.responseDelegate.navigationController().topViewController
        let parentViewController = navController.topViewController
        parentViewController?.dismiss(animated: true, completion: nil)

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
                self.responseDelegate.requestAction(command: Command(type: .userLoginServiceOffline))
                self.responseDelegate.requestAction(command: Command(type: .dismissProcessController(controller: self)))
                
            case .Authenticated:
                print("authenticated")
                self.responseDelegate.requestAction(command: Command(type: .userLoginSuccessful))
                self.responseDelegate.requestAction(command: Command(type: .dismissProcessController(controller: self)))
                
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
