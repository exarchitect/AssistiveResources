//
//  AuthenticationProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol AuthenticationCompletionProtocol {
    func authenticationCompletionAction ()
}


class AuthenticationProcessController: ProcessController, LoginViewControllerCompletionProtocol {
    
    private var responseProtocol: AuthenticationCompletionProtocol!
    private var userMC: UserModelController!
    private var loginViewController: LoginViewController!

//    private var parentVC: UIViewController?
    private var navVC: UINavigationController?

    override init() {
        
        // init ?
        
        super.init()
    }
    
//    func launch(userModelController: UserModelController, authenticationResponseProtocol: ProcessControllerCompletionProtocol, parentViewController: UIViewController) -> Bool {
    func launch(userModelController: UserModelController, authenticationResponseProtocol: AuthenticationCompletionProtocol, navController: UINavigationController) -> Bool {
        
        self.responseProtocol = authenticationResponseProtocol
        self.userMC = userModelController
//        self.parentVC = parentViewController
        self.navVC = navController
        
        let authenticationStoryboard: UIStoryboard? = UIStoryboard(name: "AuthenticationProcess", bundle: nil)
        self.loginViewController = authenticationStoryboard?.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
        self.loginViewController.setup(completionProtocol: self)
        
//        parentViewController.present(self.loginViewController, animated: false, completion: nil)
        navController.pushViewController(self.loginViewController, animated: true)
        
        return (authenticationStoryboard != nil && self.loginViewController != nil)
    }
    
    func teardown () {
//        self.parentVC?.dismiss(animated: true, completion: nil)
        let _ = self.navVC?.popViewController(animated: true)
    }
    
    //LoginViewControllerCompletionProtocol
    func loginAction (username: String, password: String) {
        self.responseProtocol.authenticationCompletionAction()
    }
    
}
