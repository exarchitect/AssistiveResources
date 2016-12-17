//
//  AppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/18/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

let memoryWarningNotificationKeyName = NSNotification.Name(rawValue: "notify_did_receive_memory_warning")


class AppController: NSObject, AuthenticationProcessControllerResponseProtocol, NavListProcessControllerResponseProtocol, EventListProcessControllerResponseProtocol, EventDetailProcessControllerResponseProtocol {

    private var rootViewController: RootViewController!
    private var navController: UINavigationController!
    
    private var authProcessController: AuthenticationProcessController!
    private var navListProcessController: NavListProcessController!
    private var evtListProcessController: EventListProcessController!
    private var evtDetailProcessController: EventDetailProcessController!
    
    private var usrModelController: UserModelController!
    private var resourcesModelController : ResourcesModelController!
    
    override init() {
        
        initializeRemoteDatabase()

        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(self.freeTerminatedProcessControllers), name: memoryWarningNotificationKeyName, object: nil)
    }
    
    func setupApplicationWindow() -> UIWindow {
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
        
        self.loadUserModelController()
        self.loadResourceModelController()

        //self.usrModelController?.storeUserCredentials(username: "exarchitect@gmail.com", password: "serveme1")
        //self.usrModelController?.storeUserCredentials(username: "", password: "")
        
        self.createNavigationListProcessController()
        let success = self.navListProcessController.launch()
        if (!success) {
        }
        
        startBackgroundActivityAlert(presentingController: self.navController.topViewController!, title: nil, message: "authenticating...")

        self.usrModelController?.authorizeUser(completion: { (success) in
            stopBackgroundActivityAlert(presentingController: self.navController.topViewController!)
            
            if (success) {
                print("logged in")
                
            } else {
                print("NOT logged in")

                self.createAuthenticationProcessController()
                let success = self.authProcessController.launch()
                if (!success) {
                    
                }
            }
        })
    }
    
    // MARK: - ProcessControllerProtocol

    func navigationController () -> UINavigationController {
        return self.navController
    }
    
    // MARK: - AuthenticationProcessControllerResponseProtocol
    
    func notifyAuthenticationCompletion () {
        
        self.authProcessController.terminate()
        
        requestMainNavigationRefresh()
    }


    // MARK: - NavListProcessControllerResponseProtocol
    
    func notifyNavigationItemSelected(selection:Destination) {

            switch selection {
            case Destination.Organizations:
                let _ = 7
                
            case Destination.Events:
                self.createEventListProcessController()
                let success = self.evtListProcessController.launch()
                if (!success) {
                    
                }
                
            case Destination.Facilities:
                freeMemory()        //
                
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
    
    // MARK: - EventListProcessControllerResponseProtocol
    
    func dismissEventProcessController () {
        self.evtListProcessController.terminate()
    }

    func notifyShowEventDetail (evt: EntityDescriptor) {
        self.createEventDetailProcessController(evt: evt)
        let success = self.evtDetailProcessController.launch()
        if (!success) {
            
        }
    }
    
    // MARK: - EventDetailProcessControllerResponseProtocol

    func dismissEventDetailProcessController () {
        self.evtDetailProcessController.terminate()
    }
    
    func notifyShowOrganizationDetail (org: EntityDescriptor) {
        
    }

    
    // MARK: - Utilities
    
    private func createAuthenticationProcessController () {
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
        self.evtListProcessController = EventListProcessController()
        self.evtListProcessController.dependencies(rsrcsModelController: self.resourcesModelController, eventProcessMessageDelegate: self)
    }
    
    private func createEventDetailProcessController (evt: EntityDescriptor) {
        freeTerminatedProcessControllers()
        
        precondition(self.resourcesModelController != nil)
        self.evtDetailProcessController = EventDetailProcessController()
        self.evtDetailProcessController.dependencies(rsrcsModelController: self.resourcesModelController, eventDetailProcessMessageDelegate: self)
    }
    
    func freeTerminatedProcessControllers () {
        if (self.authProcessController != nil && !self.authProcessController.inUse) {
            self.authProcessController = nil
        }
        if (self.navListProcessController != nil && !self.navListProcessController.inUse) {
            self.navListProcessController = nil
        }
        if (self.evtListProcessController != nil && !self.evtListProcessController.inUse) {
            self.evtListProcessController = nil
        }
        if (self.evtDetailProcessController != nil && !self.evtDetailProcessController.inUse) {
            self.evtDetailProcessController = nil
        }
    }
    
    private func loadResourceModelController () {
        if (self.resourcesModelController == nil) {
            self.resourcesModelController = ResourcesModelController()
            self.resourcesModelController.loadResources()
        }
    }
    
    private func loadUserModelController () {
        if (self.usrModelController == nil) {
            self.usrModelController = UserModelController()
        }
    }
    
}

//MARK: helper functions

func freeMemory() {
    NotificationCenter.default.post(name: memoryWarningNotificationKeyName, object: nil)
}


