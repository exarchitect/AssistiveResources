//
//  AssistiveAppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/18/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


class AssistiveAppController: AppController, RegionalResourcesProviderProtocol {
    
    private var user: UserModelController!
    private var regionalResources : RegionalResourcesModelController?
    
    
    override init() {
        super.init()
        initializeRemoteDatabase()
    }
    
    
    override func start()  {
        super.start()
        
        self.loadUserModelController()      // loadResourceModelController() not called until after login
        precondition(self.user != nil)
        
        let success = self.pushNavigationListProcessController()
        if (!success) {
            // TODO
        }
        
        // temp override to fail login for testing
        self.user.storeUserCredentials(username: "", password: "")
        
        self.user!.authorizeUser(completion: { (success) in
            
            if (success) {
                print("logged in")
                
            } else {
                print("NOT logged in")
                
                let success = self.pushAuthenticationProcessController()
                if (!success) {
                    // TODO
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
            self.loadRegionalResourceModelController()
            
        case .navigationItemSelected(let destination):
            self.notifyNavigationItemSelected(selection: destination)
            
        case .eventSelected(let event):
            let success = self.pushEventDetailProcessController(evt: event)
            if (!success) {
                // TODO
            }
            
        case .organizationSelected(let organization):
            _ = organization.entityID
        }
    }
    
    
    func notifyNavigationItemSelected(selection:Destination) {
        
        switch selection {
        case Destination.Organizations:
            let success = self.pushOrganizationListProcessController()
            if (!success) {
                // TODO
            }
            
        case Destination.Events:
            let success = self.pushEventListProcessController()
            if (!success) {
                // TODO
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
            // temp for testing
            self.user.logout()
            let success = self.self.pushAuthenticationProcessController()
            if (!success) {
                
            }
        }
        
    }
    
    
    // MARK: - RegionalResourcesProviderProtocol
    
    func sharedRegionalResources () -> RegionalResourcesModelController {
        
        return self.regionalResources!
    }

    
    // MARK: - launch process controllers
    
    private func pushNavigationListProcessController () -> Bool {
        
//        let navListPC = NavListProcessController(userModelController: self.user, responseDelegate: self)
        let navListPC = NavListProcessController(responseDelegate: self)
        navListPC.modelDependency(userModelController: self.user)
        return self.launchProcessController(processController: navListPC)
    }
    
    private func pushAuthenticationProcessController () -> Bool {
        
        let authPC = AuthenticationProcessController(responseDelegate:self)
        authPC.modelDependency(userModelController: self.user)
        return self.launchProcessController(processController: authPC)
    }
    
    private func pushEventListProcessController () -> Bool {
        
        let eventListPC = EventListProcessController(responseDelegate: self)
        eventListPC.modelDependency(rsrcsModelController: self.regionalResources!)
        return self.launchProcessController(processController: eventListPC)
    }
    
    private func pushEventDetailProcessController (evt: EntityDescriptor) -> Bool {
        
        let eventDetailPC = EventDetailProcessController(responseDelegate: self)
        eventDetailPC.modelDependency(rsrcsModelController: self.regionalResources!)
        return self.launchProcessController(processController: eventDetailPC)
    }
    
    private func pushOrganizationListProcessController () -> Bool {
        
        let orgListPC = OrganizationListProcessController(responseDelegate: self)
        orgListPC.modelDependency(rsrcsModelController: self.regionalResources!)
        return self.launchProcessController(processController: orgListPC)
    }
    
    
    // MARK: - Utilities
    
    private func launchProcessController (processController: ProcessController) -> Bool {
        let success = processController.launch()
        if success {
            self.processControllerStack.append(processController)
        }
        return success
    }
    
    private func loadRegionalResourceModelController () {
        if (self.regionalResources == nil) {
            self.regionalResources = RegionalResourcesModelController(atLocation: self.user.locationProfile)
            self.regionalResources?.initiateLoading()
        }
    }
    
    private func loadUserModelController () {
        if (self.user == nil) {
            self.user = UserModelController()
        }
    }
    
    override func checkDatabaseRefresh() {
        self.regionalResources?.checkRepositoryUpdate()
    }
    
}
