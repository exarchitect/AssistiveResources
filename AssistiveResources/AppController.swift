//
//  AppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/18/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

let memoryWarningNotificationKey = "notify_did_receive_memory_warning"


class AppController: NSObject, AuthenticationProcessControllerResponseProtocol, NavListProcessControllerResponseProtocol, EventProcessMessageProtocol {

    //private weak var topProcessController: ProcessController!
    private var rootViewController: RootViewController!
    private var navController: UINavigationController!
    
    private var authProcessController: AuthenticationProcessController!
    private var navListProcessController: NavListProcessController!
    private var eventListProcessController: EventListProcessController!
    
    private var usrModelController: UserModelController!
    private var resourcesModelController : ResourcesModelController!
    
    var username: String = ""
    
    
    //static let sharedInstance = AppController()     // singleton

    override init() {
        
        initializeRemoteDatabase()
        self.usrModelController = UserModelController()

        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(self.freeTerminatedProcessControllers), name: NSNotification.Name(rawValue: memoryWarningNotificationKey), object: nil)
    }
    
    func setup() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // create a root view controller as a backdrop for all other view controllers
        self.rootViewController = instantiateViewController(storyboardName: "Main", storyboardID: "RootViewController") as! RootViewController
        self.navController = UINavigationController(rootViewController: self.rootViewController)
        self.navController.setNavigationBarHidden(true, animated: false)

        window.rootViewController = self.navController
        
        window.makeKeyAndVisible()
        
        return window
    }
    
    func start()  {
        
        //self.userModelController?.storeUserCredentials(username: "exarchitect@gmail.com", password: "serveme1")
        //self.userModelController?.storeUserCredentials(username: "", password: "")

        self.loadResourceModelController()
        //self.navListProcessController = NavListProcessController()
        //self.navListProcessController.dependencies(userModelController: self.usrModelController, navSelectorDelegate: self)
        self.createNavigationListProcessController()
        let success = self.navListProcessController.launch(navController: self.navController)
        if (!success) {
        }
        

        self.usrModelController?.authorizeUser(completion: { (success) in
            if (success) {
                print("logged in")
                
            } else {
                print("NOT logged in")

                //self.authProcessController = AuthenticationProcessController()
                self.createAuthorizationProcessController()
                let success = self.authProcessController.launch(parentViewController:self.rootViewController)
                if (!success) {
                    
                }
            }
        })
    }
    
    
    // MARK: - AuthenticationProcessControllerResponseProtocol
    
    func authenticationCompletionAction () {
        
        self.authProcessController.terminate()
        
        requestMainNavigationRefresh()
    }


    // MARK: - NavListProcessControllerResponseProtocol
    
    func selectedNavigationItem(selection:Destination) {

            switch selection {
            case Destination.Organizations:
                let _ = 7
                
            case Destination.Events:
                //self.eventListProcessController = EventListProcessController()
                self.createEventListProcessController()
                let success = self.eventListProcessController.launch(navController: self.navController)
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
    
    // MARK: - EventSelectorProtocol
    
    func dismissEventProcessController () {
        self.eventListProcessController.terminate()
    }
    
    
    // MARK: - Utilities
    
    private func createAuthorizationProcessController () {
        freeTerminatedProcessControllers()
        
        precondition(self.usrModelController != nil)
        self.authProcessController = AuthenticationProcessController()
        self.authProcessController.dependencies(userModelController: self.usrModelController, authenticationResponseDelegate:self)
    }
    
    private func createNavigationListProcessController () {
        freeTerminatedProcessControllers()
        
        precondition(self.usrModelController != nil)
        self.navListProcessController = NavListProcessController()
        self.navListProcessController.dependencies(userModelController: self.usrModelController, navSelectorDelegate: self)
    }
    
    private func createEventListProcessController () {
        freeTerminatedProcessControllers()
        
        precondition(self.usrModelController != nil)
        self.eventListProcessController = EventListProcessController()
        self.eventListProcessController.dependencies(rsrcsModelController: self.resourcesModelController, eventProcessMessageDelegate: self)
    }
    
    func freeTerminatedProcessControllers () {
        if (self.authProcessController != nil && !self.authProcessController.inUse) {
            self.authProcessController = nil
        }
        if (self.navListProcessController != nil && !self.navListProcessController.inUse) {
            self.navListProcessController = nil
        }
        if (self.eventListProcessController != nil && !self.eventListProcessController.inUse) {
            self.eventListProcessController = nil
        }
    }
    
    private func loadResourceModelController () {
        if (self.resourcesModelController == nil) {
            self.resourcesModelController = ResourcesModelController()
            self.resourcesModelController.loadResources()
        }
    }
    
}

//MARK: helper functions

func freeMemory() {
    NotificationCenter.default.post(name: Notification.Name(rawValue: memoryWarningNotificationKey), object: nil)
}


