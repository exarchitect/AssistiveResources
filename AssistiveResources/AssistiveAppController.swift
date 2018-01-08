//
//  AssistiveAppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/18/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


struct SharedResources: RegionalResourcesProvider, UserProvider {
    var regionalResourcesModelController: RegionalResourcesModelController!
    var userModelController: UserModelController!
    //var connectivityService: ConnectivityService!
    //var interactionService: InteractionService!
}


class AssistiveAppController: AppController, ProcessControllerResponseHandler {
    
    var shared: SharedResources = SharedResources()
    
    override init() {
        super.init()
        initializeRemoteDatabase()
    }
    
    
    override func internalStart() {

        self.loadUserModelController()
        // loadResourceModelController() not called until after login
        
        let success = self.pushNavigationListProcessController()
        if (!success) {
            // TODO
        }
        
        // temp override to fail login for testing
        self.shared.userModelController.storeUserCredentials(username: "", password: "")
        //self.shared.userModelController.storeUserCredentials(username: "exarchitect@gmail.com", password: "alongishpassword")
        
        self.shared.userModelController.authorizeUser(completion: { (loginResult) in
            
            switch loginResult {
                
            case .Anonymous:
                self.loadRegionalResourceModelController(online: true)
                
            case .Authenticated:
                self.loadRegionalResourceModelController(online: true)
                requestMainNavigationRefresh()

            case .Uninitialized:
                fallthrough
                
            case .Rejected:
                print("NOT logged in")
                
                let success = self.pushAuthenticationProcessController()
                if (!success) {
                    // TODO
                }
                
            case .ServiceOffline:
                print("Service Offline")
                self.loadRegionalResourceModelController(online: false)
                
            case .NoCredentials:
                print("NO credentials")
                
                let success = self.pushAuthenticationProcessController()
                if (!success) {
                    // TODO
                }
            }
            
        })
    }
    
    
    // MARK: - ProcessControllerProtocol
    
    func requestAction(command: Command) {
        
        switch command.type {
            
        case .dismissProcessController(let controller):
            controller.terminate()
            self.freeTopProcessController()
            
        case .userLoginSuccessful:
            self.loadRegionalResourceModelController(online: true)
            
        case .userLoginServiceOffline:
            self.loadRegionalResourceModelController(online: false)
            
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
    
    
    func notifyNavigationItemSelected(selection:NavigationCategory) {
        
        switch selection {
        case NavigationCategory.Organizations:
            let success = self.pushOrganizationListProcessController()
            if (!success) {
                // TODO
            }
            
        case NavigationCategory.Events:
            let success = self.pushEventListProcessController()
            if (!success) {
                // TODO
            }
            
        case NavigationCategory.Facilities:
            let _ = 7
            
        case NavigationCategory.Travel:
            let _ = 7
            
        case NavigationCategory.News:
            let _ = 7
            
        case NavigationCategory.Inbox:
            let _ = 7
            
        case NavigationCategory.Profile:
            // temp for testing
            self.shared.userModelController.logout()
            let success = self.pushAuthenticationProcessController()
            if (!success) {
                
            }
        }
        
    }
    
    
    // MARK: - launch process controllers
    
    private func pushNavigationListProcessController () -> Bool {
        
        let navListPC = NavListProcessController(responseDelegate: self, navigationController: self.navController, dependencies: self.shared)
        return self.launchProcessController(processController: navListPC)
    }
    
    private func pushAuthenticationProcessController () -> Bool {
        
        let authPC = AuthenticationProcessController(responseDelegate:self, navigationController: self.navController, dependencies: self.shared)
        return self.launchProcessController(processController: authPC)
    }
    
    private func pushEventListProcessController () -> Bool {
        
        let eventListPC = EventListProcessController(responseDelegate: self, navigationController: self.navController, dependencies: self.shared)
        return self.launchProcessController(processController: eventListPC)
    }
    
    private func pushEventDetailProcessController (evt: EntityDescriptor) -> Bool {
        
        let eventDetailPC = EventDetailProcessController(responseDelegate: self, navController: self.navController, dependencies: self.shared)
        return self.launchProcessController(processController: eventDetailPC)
    }
    
    private func pushOrganizationListProcessController () -> Bool {
        
        let orgListPC = OrganizationListProcessController(responseDelegate: self, navigationController: self.navController, dependencies: self.shared)
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
    
    private func loadRegionalResourceModelController (online: Bool) {
        if (self.shared.regionalResourcesModelController == nil) {
            self.shared.regionalResourcesModelController = RegionalResourcesModelController(atLocation: self.shared.userModelController.locationProfile, isOnline: online)
            self.shared.regionalResourcesModelController?.initiateLoading()
        }
    }
    
    private func loadUserModelController () {
        if (self.shared.userModelController == nil) {
            self.shared.userModelController = UserModelController()
        }
        precondition(self.shared.userModelController != nil)
    }
    
    override func checkDatabaseRefresh() {
        self.shared.regionalResourcesModelController?.checkRepositoryUpdate()
    }
    
}
