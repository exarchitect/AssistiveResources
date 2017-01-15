//
//  AuthenticationProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


//protocol AuthenticationProcessControllerResponseProtocol: ProcessControllerProtocol {
//    func loginComplete ()
//}


class AuthenticationProcessController: ProcessController, LoginViewControllerCompletionProtocol {
    
    private var responseDelegate: ProcessControllerProtocol!
    private var user: UserModelController!
    private var loginViewController: LoginViewController!

    init(userModelController: UserModelController, responseDelegate: ProcessControllerProtocol) {
        
        self.responseDelegate = responseDelegate
        self.user = userModelController
    }
    
    func launch() -> Bool {
        
        let authenticationStoryboard: UIStoryboard? = UIStoryboard(name: "AuthenticationProcess", bundle: nil)
        self.loginViewController = authenticationStoryboard?.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
        self.loginViewController.dependencies(userModelController: self.user, completionProtocol: self)
        
        let parentViewController = self.responseDelegate.navigationController().topViewController
        parentViewController?.present(self.loginViewController, animated: true, completion: nil)
        
        return (authenticationStoryboard != nil && self.loginViewController != nil)
    }
    
    override func terminate () {
        super.terminate()

        let parentViewController = self.responseDelegate.navigationController().topViewController
        parentViewController?.dismiss(animated: true, completion: nil)
        
        requestMainNavigationRefresh()
    }
    
    //LoginViewControllerCompletionProtocol

    func loginAction (username: String, password: String) {
//        self.responseProtocol.loginComplete()
//        self.responseProtocol.dismissProcessController(controller: self)

        self.responseDelegate.requestAction(command: Command(type: Command.CommandType.userLoginSuccessful))
        let cmd = Command(type: Command.CommandType.dismissCaller(controller: self))
        self.responseDelegate.requestAction(command: cmd)

    }
    
    //MARK: debug
    deinit {
        print("deallocating AuthenticationProcessController")
    }
    
}
