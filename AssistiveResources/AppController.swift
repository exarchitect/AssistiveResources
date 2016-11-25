//
//  AppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/18/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

class AppController: NSObject, ProcessControllerCompletionProtocol {

    private var topProcessController: ProcessController!
    private var rootViewController: RootViewController!
    private var authProcessController: AuthenticationProcessController!
    
    private var userModelController: UserModelController!
    private var resourcesModelController : ResourcesModelController
    
    var username: String = ""
    
    //static let sharedInstance = AppController()     // singleton

    override init() {
        
        initializeDatabase()
        self.userModelController = UserModelController()
        self.resourcesModelController = ResourcesModelController()
        
        super.init()
    }
    
    func setup() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // create a root view controller as a backdrop for all other view controllers
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        window.rootViewController = self.rootViewController
        window.makeKeyAndVisible()
        
        return window
    }
    
    func start()  {
        
        //self.userModelController?.storeUserCredentials(username: "exarchitect@gmail.com", password: "serveme1")

        self.userModelController?.authorizeUser(completion: { (success) in
            if (success) {
                print("logged in")
                // launch the mainnav processcontroller
            } else {
                print("NOT logged in")
                // launch the login processcontroller
                self.authProcessController = AuthenticationProcessController()
                let success = self.authProcessController.push(userModelController: self.userModelController, authenticationResponseProtocol:self, parentViewController:self.rootViewController)
                if (!success) {
                    
                }
            }
        })
    }
    
    
    //ProcessControllerCompletionProtocol
    func completionAction (action: ProcessCompletionAction, teardown: ProcessCompletionDisposition) -> Bool {
        self.authProcessController.teardown()
        return true
    }
}


