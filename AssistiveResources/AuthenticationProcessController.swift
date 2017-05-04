//
//  AuthenticationProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class AuthenticationProcessController: ProcessController, LoginViewControllerCompletionProtocol {
    
    typealias Dependencies = UserProvider
    
    let dependencies: Dependencies

    //private var responseDelegate: ProcessControllerProtocol!
//    private var user: UserModelController!
    private var loginViewController: LoginViewController!

//    init(userModelController: UserModelController, responseDelegate: ProcessControllerProtocol) {
//        
//        self.responseDelegate = responseDelegate
//        self.user = userModelController
//    }
    
    init(responseDelegate: ProcessControllerProtocol, dependencies: Dependencies) {
        self.dependencies = dependencies
        
        // TEMP
//        self.user = dependencies.userModelController
        super.init(responseDelegate: responseDelegate)
    }
    
//    func modelDependency(userModelController: UserModelController) {
//        
//        self.user = userModelController
//    }
    
    override func launch() -> Bool {
        
        let authenticationStoryboard: UIStoryboard? = UIStoryboard(name: "AuthenticationProcess", bundle: nil)
        self.loginViewController = authenticationStoryboard?.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
//        self.loginViewController.dependencies(userModelController: self.user, completionProtocol: self)
        self.loginViewController.dependencies(userModelController: self.dependencies.userModelController, completionProtocol: self)
        
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
        //self.user.storeUserCredentials(username: "fail", password: password)
        self.dependencies.userModelController.authorizeUser(completion: { (success) in
            
            if (success) {
                print("logged in")
                
                let cmd = Command(type: .dismissCaller(controller: self))
                self.responseDelegate.requestAction(command: cmd)
                
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
