//
//  AuthenticationProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class AuthenticationProcessController: ProcessController, LoginViewControllerCompletionProtocol {
    
    private var responseProtocol: ProcessControllerCompletionProtocol!
    private var userMC: UserModelController!
    private var loginViewController: LoginViewController!
    private var parentVC: UIViewController?

    override init() {
        
        // init ?
        
        super.init()
    }
    
    func push(userModelController: UserModelController, authenticationResponseProtocol: ProcessControllerCompletionProtocol, parentViewController: UIViewController) -> Bool {
        
        self.responseProtocol = authenticationResponseProtocol
        self.userMC = userModelController
        self.parentVC = parentViewController
        
        let authenticationStoryboard: UIStoryboard = UIStoryboard(name: "AuthenticationProcess", bundle: nil)
        self.loginViewController = authenticationStoryboard.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
        self.loginViewController.setup(completionProtocol: self)
        
        parentViewController.present(self.loginViewController, animated: false, completion: nil)
        
        return true
    }
    
    func teardown () {
        self.parentVC?.dismiss(animated: true, completion: nil)
    }
    
    //LoginViewControllerCompletionProtocol
    func loginAction (username: String, password: String) {
        let _ = self.responseProtocol.completionAction(action: ProcessCompletionAction.selectEvent, teardown: ProcessCompletionDisposition.close)
    }
    
}
