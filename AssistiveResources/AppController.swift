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
        
        // create a root view controller
        self.rootViewController = instantiateViewController(storyboardName: "Main", storyboardID: "RootViewController") as! RootViewController
        self.navController = UINavigationController(rootViewController: self.rootViewController)
        self.navController.setNavigationBarHidden(true, animated: false)

        window.rootViewController = self.navController
        window.makeKeyAndVisible()
        
        return window
    }
    
    
    func start()  {
        self.loadUserModelController()
//        self.loadResourceModelController()        // moved to after login

        //self.usrModelController?.storeUserCredentials(username: "exarchitect@gmail.com", password: "serveme1")
        //self.usrModelController?.storeUserCredentials(username: "", password: "")
        
        let success = self.pushNavigationListProcessController()
        if (!success) {
        }
        
        startBackgroundActivityAlert(presentingController: self.navController.topViewController!, title: nil, message: "authenticating...")

        self.usrModelController?.authorizeUser(completion: { (success) in
            stopBackgroundActivityAlert(presentingController: self.navController.topViewController!)
            
            if (success) {
                print("logged in")
                
            } else {
                print("NOT logged in")

                let success = self.self.pushAuthenticationProcessController()
                if (!success) {
                    
                }
            }
        })
    }
    
    
    // MARK: - ProcessControllerProtocol

    func dismissProcessController (controller: ProcessController) {
        controller.terminate()
        
    }

    func navigationController () -> UINavigationController {
        return self.navController
    }
    
    
    // MARK: - AuthenticationProcessControllerResponseProtocol
    func loginComplete() {
        self.loadResourceModelController(atLocation:LocationProfile(zip: "40205"))
        
    }
    

    // MARK: - NavListProcessControllerResponseProtocol
    
    func notifyNavigationItemSelected(selection:Destination) {

            switch selection {
            case Destination.Organizations:
                let _ = 7
                
            case Destination.Events:
                let success = self.pushEventListProcessController()
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
                // temp for testing
                self.usrModelController.logout()
                let success = self.self.pushAuthenticationProcessController()
                if (!success) {
                    
                }
            }

    }
    
    
    // MARK: - EventListProcessControllerResponseProtocol
    
    func notifyShowEventDetail (evt: EntityDescriptor) {
        let success = self.pushEventDetailProcessController(evt: evt)
        if (!success) {
            
        }
    }
    
    
    // MARK: - EventDetailProcessControllerResponseProtocol

    func notifyShowOrganizationDetail (org: EntityDescriptor) {
        let _ = 4
    }

    
    // MARK: - Utilities
    
    private func pushAuthenticationProcessController () -> Bool {
        freeTerminatedProcessControllers()
        
        precondition(self.usrModelController != nil)
        self.authProcessController = AuthenticationProcessController(userModelController: self.usrModelController, authenticationResponseDelegate:self)
        
        return self.authProcessController.launch()
    }
    
    private func pushNavigationListProcessController () -> Bool {
        freeTerminatedProcessControllers()
        
        precondition(self.usrModelController != nil)
        self.navListProcessController = NavListProcessController(userModelController: self.usrModelController, navDelegate: self)
        
        return self.navListProcessController.launch()
    }
    
    private func pushEventListProcessController () -> Bool {
        freeTerminatedProcessControllers()
        
        precondition(self.usrModelController != nil)
        self.evtListProcessController = EventListProcessController(rsrcsModelController: self.resourcesModelController, eventProcessMessageDelegate: self)
        
        return self.evtListProcessController.launch()
    }
    
    private func pushEventDetailProcessController (evt: EntityDescriptor) -> Bool {
        freeTerminatedProcessControllers()
        
        precondition(self.resourcesModelController != nil)
        self.evtDetailProcessController = EventDetailProcessController(rsrcsModelController: self.resourcesModelController, eventDetailProcessMessageDelegate: self)
        
        return self.evtDetailProcessController.launch()
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
    
    private func loadResourceModelController (atLocation: LocationProfile) {
        if (self.resourcesModelController == nil) {
            self.resourcesModelController = ResourcesModelController()
            self.resourcesModelController.initiateLoading()
        }
    }
    
    private func loadUserModelController () {
        if (self.usrModelController == nil) {
            self.usrModelController = UserModelController()
        }
    }
    
}


//MARK: - functions

func freeMemory() {
    NotificationCenter.default.post(name: memoryWarningNotificationKeyName, object: nil)
}


