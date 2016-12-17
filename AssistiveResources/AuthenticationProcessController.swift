//
//  AuthenticationProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol AuthenticationProcessControllerResponseProtocol: ProcessControllerProtocol {

}


class AuthenticationProcessController: ProcessController, LoginViewControllerCompletionProtocol {
    
    private var responseProtocol: AuthenticationProcessControllerResponseProtocol!
    private var usrModelController: UserModelController!
    private var loginViewController: LoginViewController!

    override init() {
        // init ?
        
        super.init()
    }
    
    func dependencies(userModelController: UserModelController, authenticationResponseDelegate: AuthenticationProcessControllerResponseProtocol) {
        
        self.responseProtocol = authenticationResponseDelegate
        self.usrModelController = userModelController
    }
    
    func launch() -> Bool {
        
        let authenticationStoryboard: UIStoryboard? = UIStoryboard(name: "AuthenticationProcess", bundle: nil)
        self.loginViewController = authenticationStoryboard?.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
        self.loginViewController.dependencies(userModelController: self.usrModelController, completionProtocol: self)
        
        let parentViewController = self.responseProtocol.navigationController().topViewController
        parentViewController?.present(self.loginViewController, animated: true, completion: nil)
        
        return (authenticationStoryboard != nil && self.loginViewController != nil)
    }
    
    override func terminate () {
        super.terminate()

        let parentViewController = self.responseProtocol.navigationController().topViewController
        parentViewController?.dismiss(animated: true, completion: nil)
        
        requestMainNavigationRefresh()
    }
    
    //LoginViewControllerCompletionProtocol

    func loginAction (username: String, password: String) {
        self.responseProtocol.dismissProcessController(controller: self)
    }
    
}
