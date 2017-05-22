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

    init(responseDelegate: ProcessControllerProtocol, dependencies: ExternalDependencies) {
        self.dependencies = dependencies
        super.init(responseDelegate: responseDelegate)
    }
    
    override func launch() -> Bool {
        
        let authenticationStoryboard: UIStoryboard? = UIStoryboard(name: "AuthenticationProcess", bundle: nil)
        self.loginViewController = authenticationStoryboard?.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
        self.loginViewController.configuration(userModelController: self.dependencies.userModelController, completionProtocol: self)
        
        let parentViewController = self.responseDelegate.navigationController().topViewController
        parentViewController?.present(self.loginViewController, animated: true, completion: nil)
        
        return (authenticationStoryboard != nil && self.loginViewController != nil)
    }
    
    override func terminate () {
        super.terminate()

        let parentViewController = self.responseDelegate.navigationController().topViewController
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 0.3)) {
            parentViewController?.dismiss(animated: true, completion: nil)
        }
        
        requestMainNavigationRefresh()
    }
    

    // LoginViewControllerCompletionProtocol
    
    func loginAction (username: String, password: String) {

        self.dependencies.userModelController.storeUserCredentials(username: username, password: password)

        self.dependencies.userModelController.authorizeUser(completion: { (success) in
            
            if (success) {
                print("logged in")
                
                self.responseDelegate.requestAction(command: Command(type: .dismissProcessController(controller: self)))
                self.responseDelegate.requestAction(command: Command(type: .userLoginSuccessful))

            } else {
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
