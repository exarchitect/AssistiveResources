//
//  AppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/18/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

class AppController: NSObject, AuthenticationCompletionProtocol, NavListCompletionProtocol {

    private var topProcessController: ProcessController!
    private var rootViewController: RootViewController!
    private var navController: UINavigationController!
    
    private var authProcessController: AuthenticationProcessController!
    private var navListProcessController: NavListProcessController!
    
    private var userModelController: UserModelController!
    private var resourcesModelController : ResourcesModelController
    
    var username: String = ""
    
    //static let sharedInstance = AppController()     // singleton

    override init() {
        
        initializeRemoteDatabase()
        self.userModelController = UserModelController()
        self.resourcesModelController = ResourcesModelController()
        
        super.init()
    }
    
    func setup() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // create a root view controller as a backdrop for all other view controllers
        let mainStoryboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
        self.rootViewController = mainStoryboard?.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        self.navController = UINavigationController(rootViewController: self.rootViewController)
        self.navController.setNavigationBarHidden(true, animated: false)

//        window.rootViewController = self.rootViewController
        window.rootViewController = self.navController
        
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

                self.authProcessController = AuthenticationProcessController()
//                let success = self.authProcessController.launch(userModelController: self.userModelController, authenticationResponseProtocol:self, parentViewController:self.rootViewController)
                let success = self.authProcessController.launch(userModelController: self.userModelController, authenticationResponseProtocol:self, navController: self.navController)
                if (!success) {
                    
                }
            }
        })
    }
    
    
    // AuthenticationCompletionProtocol
    func authenticationCompletionAction () {
        // take action
        
        self.authProcessController.teardown()
        
        self.navListProcessController = NavListProcessController()
        let success = self.navListProcessController.launch(userModelController: self.userModelController, navListResponseProtocol:self, navController: self.navController)
        if (!success) {
            
        }
    }


    // NavListCompletionProtocol
    func navListCompletionAction() {
        // take action
        
        self.authProcessController.teardown()
        
//        self.navListProcessController = NavListProcessController()
//        let success = self.navListProcessController.launch(userModelController: self.userModelController, navListResponseProtocol:self, navController: self.navController)
//        if (!success) {
//            
//        }
    }
}


