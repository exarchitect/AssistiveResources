//
//  AuthenticationProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol AuthenticationProcessControllerResponseProtocol {
    func notifyAuthenticationCompletion ()
}


class AuthenticationProcessController: ProcessController, LoginViewControllerCompletionProtocol {
    
    private var responseProtocol: AuthenticationProcessControllerResponseProtocol!
    private var userMC: UserModelController!
    private var loginViewController: LoginViewController!

    private var parentVC: UIViewController?

    
    override init() {
        // init ?
        
        super.init()
    }
    
    func dependencies(userModelController: UserModelController, authenticationResponseDelegate: AuthenticationProcessControllerResponseProtocol) {
        
        self.responseProtocol = authenticationResponseDelegate
        self.userMC = userModelController
    }
    
    func launch(parentViewController: UIViewController) -> Bool {
        
        //self.responseProtocol = authenticationResponseDelegate
        //self.userMC = userModelController
        self.parentVC = parentViewController
        
        let authenticationStoryboard: UIStoryboard? = UIStoryboard(name: "AuthenticationProcess", bundle: nil)
        self.loginViewController = authenticationStoryboard?.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
        self.loginViewController.dependencies(completionProtocol: self)
        
        parentViewController.present(self.loginViewController, animated: true, completion: nil)
        
        return (authenticationStoryboard != nil && self.loginViewController != nil)
    }
    
    override func terminate () {
        super.terminate()
        self.parentVC?.dismiss(animated: true, completion: nil)
    }
    
    //LoginViewControllerCompletionProtocol
    func loginAction (username: String, password: String) {
        self.responseProtocol.notifyAuthenticationCompletion()
    }
    
}
