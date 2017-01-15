//
//  AssitiveAppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/15/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


class AssitiveAppController: AppController {
    
        private var user: UserModelController!
        private var regionalResources : RegionalResourcesModelController!
        
        
        override init() {
            super.init()
            initializeRemoteDatabase()
        }
        
        
        override func start()  {
            super.start()
            
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
        
        override func requestAction(command: Command) {
            
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
                let _ = 7
                //freeMemory()
                
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
            let navListPC = NavListProcessController(userModelController: self.user, responseDelegate: self)
            
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
