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


class AssistiveAppController: AppController, ProcessControllerResponseProtocol {
    
    var shared: SharedResources = SharedResources()
    
    override init() {
        super.init()
        initializeRemoteDatabase()
    }
    
    
    override func internalStart() {

        self.loadUserModelController()
        // loadResourceModelController() not called until after login
        
        self.pushNavigationListProcessController()
        
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
                
                self.pushAuthenticationProcessController()
                
            case .ServiceOffline:
                print("Service Offline")
                self.loadRegionalResourceModelController(online: false)
                
            case .NoCredentials:
                print("NO credentials")
                
                self.pushAuthenticationProcessController()
            }
            
        })
    }
    
    
    // MARK: - ProcessControllerProtocol
    
    func requestAction(command: Command) {
        
        switch command.type {
            
        case .dismissProcessController(let controller):
            controller.terminate()
            self.freeTopProcessController()
            
        case .dismissTopProcessController():
            let pController: ProcessController? = self.getTopProcessController()
            if let pController = pController {
                pController.terminate()
                self.freeTopProcessController()
            }

        case .userLoginSuccessful:
            self.loadRegionalResourceModelController(online: true)
            
        case .userLoginServiceOffline:
            self.loadRegionalResourceModelController(online: false)
            
        case .navigationItemSelected(let destination):
            self.respondToNavigationItemSelected(selection: destination)
            
        case .eventSelected(let event):
            self.pushEventDetailProcessController(evt: event)
            
        case .organizationSelected(let organization):
            _ = organization.entityID
        }
    }
    
    
    // MARK: - Utilities
    
    func respondToNavigationItemSelected(selection:NavigationCategory) {
        
        switch selection {
        case NavigationCategory.Organizations:
            self.pushOrganizationListProcessController()
            
        case NavigationCategory.Events:
            self.pushEventListProcessController()
            
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
            self.pushAuthenticationProcessController()
        }
        
    }
    
    
    private func pushNavigationListProcessController () {
        
        let navListPC = NavListProcessController(responseDelegate: self, navigationController: self.navController, dependencies: self.shared)
        self.launchProcessController(processController: navListPC)
    }
    
    private func pushAuthenticationProcessController () {
        
        let authPC = AuthenticationProcessController(responseDelegate:self, navigationController: self.navController, dependencies: self.shared)
        self.launchProcessController(processController: authPC)
    }
    
    private func pushEventListProcessController () {
        
        let eventListPC = EventListProcessController(responseDelegate: self, navigationController: self.navController, dependencies: self.shared)
        self.launchProcessController(processController: eventListPC)
    }
    
    private func pushEventDetailProcessController (evt: EntityDescriptor) {
        
        let eventDetailPC = EventDetailProcessController(responseDelegate: self, navController: self.navController, dependencies: self.shared)
        self.launchProcessController(processController: eventDetailPC)
    }
    
    private func pushOrganizationListProcessController () {
        
        let orgListPC = OrganizationListProcessController(responseDelegate: self, navigationController: self.navController, dependencies: self.shared)
        self.launchProcessController(processController: orgListPC)
    }
    
    
    private func launchProcessController (processController: ProcessController) {
        processController.launch()
        self.processControllerStack.append(processController)
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
