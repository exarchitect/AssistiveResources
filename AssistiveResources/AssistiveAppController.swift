//
//  AssistiveAppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/18/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


struct SharedServices: RegionalResourcesProvider, UserProvider {
    var regionalResourcesModelController: RegionalResourcesModelController!
    var userModelController: UserModelController!
    //var connectivityService: ConnectivityService!
    //var interactionService: InteractionService!
}


class AssistiveAppController: AppController, ProcessControllerResponseProtocol {
    
    var shared: SharedServices = SharedServices()
    
    override init() {
        super.init()
        initializeRemoteDatabase()
    }
    
    
    override func internalStart() {

        self.loadUserModelController()        // other model controllers not called until after login
        
        self.pushNavigationListProcessController()
        
        // temp override to fail login for testing
        self.shared.userModelController.storeUserCredentials(username: "", password: "")
        //self.shared.userModelController.storeUserCredentials(username: "exarchitect@gmail.com", password: "alongishpassword")
        
        self.shared.userModelController.authorizeUser(completion: { (loginResult) in
            
            switch loginResult {
                
            case .Anonymous:
                self.loadRegionalResourceModelController(online: true)
                requestMainNavigationRefresh()

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
    
    
    // MARK: - ProcessControllerResponseProtocol
    
    func requestAction(command: AssistiveCommand) {
        
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
    
    
    // MARK: - process controller handling

    private func pushNavigationListProcessController () {
        
        let navListPC = NavListProcessController(responseDelegate: self, navController: self.navController, services: self.shared)
        navListPC.launch()
        self.processControllerStack.append(navListPC)
    }
    
    private func pushAuthenticationProcessController () {
        
        let authPC = AuthenticationProcessController(responseDelegate:self, navController: self.navController, services: self.shared)
        authPC.launch()
        self.processControllerStack.append(authPC)
    }
    
    private func pushEventListProcessController () {
        
        let eventListPC = EventListProcessController(responseDelegate: self, navController: self.navController, services: self.shared)
        eventListPC.launch()
        self.processControllerStack.append(eventListPC)
    }
    
    private func pushEventDetailProcessController (evt: EntityDescriptor) {
        
        let eventDetailPC = EventDetailProcessController(responseDelegate: self, navController: self.navController, services: self.shared)
        eventDetailPC.launch()
        self.processControllerStack.append(eventDetailPC)
    }
    
    private func pushOrganizationListProcessController () {
        
        let orgListPC = OrganizationListProcessController(responseDelegate: self, navController: self.navController, services: self.shared)
        orgListPC.launch()
        self.processControllerStack.append(orgListPC)
    }
    
    
    // MARK: - model controller handling

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
    
    
    // MARK: - db Utilities

    override func checkDatabaseRefresh() {
        self.shared.regionalResourcesModelController?.checkRepositoryUpdate()
    }
    
}
