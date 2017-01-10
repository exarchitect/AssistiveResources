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
    
    private var user: UserModelController!
    private var regionalResources : RegionalResourcesModelController!
    
    
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
        self.loadUserModelController()      // loadResourceModelController() not called until after login

        //self.usrModelController?.storeUserCredentials(username: "exarchitect@gmail.com", password: "serveme1")
        //self.usrModelController?.storeUserCredentials(username: "", password: "")
        
        let success = self.pushNavigationListProcessController()
        if (!success) {
        }
        
        startBackgroundActivityAlert(presentingController: self.navController.topViewController!, title: nil, message: "authenticating...")

        self.user?.authorizeUser(completion: { (success) in
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
        
        self.loadRegionalResourceModelController(atLocation:self.user.location)
        
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
                self.user.logout()
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
        
        precondition(self.user != nil)
        self.authProcessController = AuthenticationProcessController(userModelController: self.user, authenticationResponseDelegate:self)
        
        return self.authProcessController.launch()
    }
    
    private func pushNavigationListProcessController () -> Bool {
        freeTerminatedProcessControllers()
        
        precondition(self.user != nil)
        self.navListProcessController = NavListProcessController(userModelController: self.user, navDelegate: self)
        
        return self.navListProcessController.launch()
    }
    
    private func pushEventListProcessController () -> Bool {
        freeTerminatedProcessControllers()
        
        precondition(self.user != nil)
        self.evtListProcessController = EventListProcessController(rsrcsModelController: self.regionalResources, eventProcessMessageDelegate: self)
        
        return self.evtListProcessController.launch()
    }
    
    private func pushEventDetailProcessController (evt: EntityDescriptor) -> Bool {
        freeTerminatedProcessControllers()
        
        precondition(self.regionalResources != nil)
        self.evtDetailProcessController = EventDetailProcessController(rsrcsModelController: self.regionalResources, eventDetailProcessMessageDelegate: self)
        
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
    
    private func loadRegionalResourceModelController (atLocation: LocationProfile) {
        if (self.regionalResources == nil) {
            self.regionalResources = RegionalResourcesModelController()
            self.regionalResources.initiateLoading()
        }
    }
    
    private func loadUserModelController () {
        if (self.user == nil) {
            self.user = UserModelController()
        }
    }
    
}


//MARK: - functions

func freeMemory() {
    NotificationCenter.default.post(name: memoryWarningNotificationKeyName, object: nil)
}


