//
//  AppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/18/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

let memoryWarningNotificationKeyName = NSNotification.Name(rawValue: "notify_did_receive_memory_warning")


class AppController: NSObject, ProcessControllerProtocol {

    private var rootViewController: RootViewController!
    private var navController: UINavigationController!
    private var processControllerStack = [ProcessController()]
    
    private var user: UserModelController!
    private var regionalResources : RegionalResourcesModelController!
    
    
    override init() {
        initializeRemoteDatabase()
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.freeTopProcessController), name: memoryWarningNotificationKeyName, object: nil)
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

    func navigationController () -> UINavigationController {
        return self.navController
    }
    
    func requestAction(command: Command) {
        
        switch command.type {
        case .dismissCaller(let controller):
            controller.terminate()
            self.freeTopProcessController()
            
        case .userLoginSuccessful:
            self.loadRegionalResourceModelController(atLocation:self.user.location)

        case .navigationItemSelected(let destination):
            self.notifyNavigationItemSelected(selection: destination)
            
        case .eventSelected(let event):
            let success = self.pushEventDetailProcessController(evt: event)
            if (!success) {
                
            }

        case .organizationSelected(let organization):
            _ = organization.entityID
        }
    }
    
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
    
    
    // MARK: - Utilities
    
    private func pushNavigationListProcessController () -> Bool {
        precondition(self.user != nil)
        let navListPC = NavListProcessController(userModelController: self.user, navDelegate: self)
        
        let success = navListPC.launch()
        if success {
            self.processControllerStack.append(navListPC)
        }
        return success
    }

    private func pushAuthenticationProcessController () -> Bool {
        precondition(self.user != nil)
        let authPC = AuthenticationProcessController(userModelController: self.user, responseDelegate:self)
        
        let success = authPC.launch()
        if success {
            self.processControllerStack.append(authPC)
        }
        return success
    }

    private func pushEventListProcessController () -> Bool {
        precondition(self.user != nil)
        let eventListPC = EventListProcessController(rsrcsModelController: self.regionalResources, responseDelegate: self)
        
        let success = eventListPC.launch()
        if success {
            self.processControllerStack.append(eventListPC)
        }
        return success
    }
    
    private func pushEventDetailProcessController (evt: EntityDescriptor) -> Bool {
        precondition(self.regionalResources != nil)
        let eventDetailPC = EventDetailProcessController(rsrcsModelController: self.regionalResources, responseDelegate: self)
        
        let success = eventDetailPC.launch()
        if success {
            self.processControllerStack.append(eventDetailPC)
        }
        return success
    }

//    func freeTerminatedProcessControllers () {
//        if (self.processControllerStack.last != nil){
//            if (!self.processControllerStack.last!.inUse) {
//                self.processControllerStack.popLast()
//            }
//        }
//    }
    
    func freeTopProcessController () {
        if (self.processControllerStack.last != nil){
            if (!self.processControllerStack.last!.inUse) {
                let _ = self.processControllerStack.popLast()
            }
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


