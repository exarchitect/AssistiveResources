//
//  AuthenticationProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

class AuthenticationProcessController: ProcessController {
    
    private var responseProtocol: ProcessControllerCompletionProtocol!
    private var userMC: UserModelController!
    private var loginViewController: LoginViewController!

    override init() {
        
        // init ?
        
        super.init()
    }
    
    func push(userModelController: UserModelController, authenticationResponseProtocol: ProcessControllerCompletionProtocol) -> Bool {
        
        self.responseProtocol = authenticationResponseProtocol
        self.userMC = userModelController
        
        let authenticationStoryboard: UIStoryboard = UIStoryboard(name: "AuthenticationProcess", bundle: nil)
        self.loginViewController = authenticationStoryboard.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
        
        return true
    }
    
}
