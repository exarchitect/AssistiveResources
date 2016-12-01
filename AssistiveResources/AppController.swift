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
        //self.userModelController?.storeUserCredentials(username: "", password: "")


        self.userModelController?.authorizeUser(completion: { (success) in
            if (success) {
                print("logged in")
                
                // launch the mainnav processcontroller
                self.navListProcessController = NavListProcessController()
                let success = self.navListProcessController.launch(userModelController: self.userModelController, navListResponseDelegate:self, navController: self.navController)
                if (!success) {
                    
                }
                
            } else {
                print("NOT logged in")

                self.authProcessController = AuthenticationProcessController()
                let success = self.authProcessController.launch(userModelController: self.userModelController, authenticationResponseDelegate:self, parentViewController:self.rootViewController)
                if (!success) {
                    
                }
            }
        })
    }
    
    
    // AuthenticationCompletionProtocol
    func authenticationCompletionAction () {
        // take action
        
        self.authProcessController.teardown()
        self.authProcessController = nil
        
        self.navListProcessController = NavListProcessController()
        let success = self.navListProcessController.launch(userModelController: self.userModelController, navListResponseDelegate:self, navController: self.navController)
        if (!success) {
            
        }
    }


    // NavListCompletionProtocol
    func navListAction(selection:Destination) {
        // take action

            switch selection {
            case Destination.Organizations:
                let _ = 7
                
            case Destination.Events:
                let _ = 7
                
            case Destination.Facilities:
                let _ = 7
                
            case Destination.Travel:
                let _ = 7
                
            case Destination.News:
                let _ = 7
                
            case Destination.Inbox:
                let _ = 7
                
            case Destination.Profile:
                // TEMP
                let _ = 7
                //let user = AuthenticatedUser.sharedInstance
                //AuthenticatedUser.sharedInstance.logout()
            }
            

        
//        self.navListProcessController = NavListProcessController()
//        let success = self.navListProcessController.launch(userModelController: self.userModelController, navListResponseProtocol:self, navController: self.navController)
//        if (!success) {
//            
//        }
    }
}


