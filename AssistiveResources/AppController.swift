//
//  AppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/18/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

class AppController: NSObject, AuthenticationCompletionProtocol, NavigationSelectorProtocol, EventSelectorProtocol {

    private var topProcessController: ProcessController!
    private var rootViewController: RootViewController!
    private var navController: UINavigationController!
    
    private var authProcessController: AuthenticationProcessController!
    private var navListProcessController: NavListProcessController!
    private var eventListProcessController: EventListProcessController!
    
    private var userModelController: UserModelController!
    private var resourcesModelController : ResourcesModelController!
    
    var username: String = ""
    
    
    //static let sharedInstance = AppController()     // singleton

    override init() {
        
        initializeRemoteDatabase()
        self.userModelController = UserModelController()
        
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

        self.loadResourceModelController()
        self.navListProcessController = NavListProcessController()
        let success = self.navListProcessController.launch(userModelController: self.userModelController, navSelectorDelegate:self, navController: self.navController)
        if (!success) {
            
        }
        

        self.userModelController?.authorizeUser(completion: { (success) in
            if (success) {
                print("logged in")
                
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
        
        self.authProcessController.teardown()
        //self.authProcessController = nil      // TODO - need to free this later
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: updateNotificationKey), object: nil)
    }


    // NavListCompletionProtocol
    func selectedNavigationItem(selection:Destination) {

            switch selection {
            case Destination.Organizations:
                let _ = 7
                
            case Destination.Events:
                self.eventListProcessController = EventListProcessController()
                let success = self.eventListProcessController.launch(rsrcsModelController: self.resourcesModelController, eventSelectorDelegate: self, navController: self.navController)
                if (!success) {
                    
                }
                
            case Destination.Facilities:
                let _ = 7
                
            case Destination.Travel:
                let _ = 7
                
            case Destination.News:
                let _ = 7
                
            case Destination.Inbox:
                let _ = 7
                
            case Destination.Profile:
                let _ = 7
            }

    }
    
    // AuthenticationCompletionProtocol
    func selectedEvent(selection: Int) {
        
        
    }
    
    
    private func loadResourceModelController () {
        if (self.resourcesModelController == nil) {
            self.resourcesModelController = ResourcesModelController()
            self.resourcesModelController.loadResources()
        }
    }
  
}


