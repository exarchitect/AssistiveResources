//
//  AssistiveAppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/18/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

// MARK: -TO DO LIST-
// TODO: Filter (UI and model) for EventList
// TODO: Organization Detail
// TODO: Filter for OrganizationList
// TODO: **DONE** Remote data source
// TODO: CocoaLumberjack
// TODO: Timepiece cocoapod
// TODO: Unit Tests for models
// TODO: UI Unit Tests -


struct SharedServices: RegionalResourcesProvider, UserProvider {
    var regionalResourcesModelController: RegionalResourcesModelController!
    var userModelController: UserModelController!
    var connectivityService: ConnectivityService!
    //var interactionService: InteractionService!
}


class AssistiveAppController: AppController, CommandResponseProtocol {
    
    var shared: SharedServices = SharedServices()
    //var commandLog = [AssistiveCommand]()

    override init() {
        super.init()
        initializeRemoteDatabase()
    }
    
    
    override func internalStart() {

        self.loadUserModelController()        // other model controllers not called until after login
        self.loadConnectivityService()
        
        self.pushProcessController(type: NavListProcessController.self)

        // temp override to fail login for testing
        self.shared.userModelController.storeUserCredentials(username: "", password: "")
        //self.shared.userModelController.storeUserCredentials(username: "exarchitect@gmail.com", password: "alongishpassword")
        
        self.shared.userModelController.authorizeUser(completion: { (loginResult) in
            
            switch loginResult {
                
            case .Anonymous:
                fallthrough

            case .Authenticated:
                self.invokeAction(command: AssistiveCommand(type: .userIdentified))

            case .Uninitialized:
                fallthrough
                
            case .Rejected:
                fallthrough
                
            case .NoCredentials:
                self.invokeAction(command: AssistiveCommand(type: .identifyUser))
            }
        })
    }
    
    
    // MARK: - CommandResponseProtocol
    
    func invokeAction(command: AssistiveCommand) {
        
        print("-- invokeAction: \(command.type)")

        switch command.type {
            
        case .dismissProcessController():
            let pController: ProcessController? = self.getTopProcessController()
            if let pController = pController {
                pController.terminate()
                self.freeTopProcessController()
            }
            
        case .identifyUser:
            self.pushProcessController(type: AuthenticationProcessController.self)

        case .userIdentified:
            self.loadRegionalResourceModelController(online: true)
            requestMainNavigationRefresh()

        case .navigateTo(let destination):
            print(" -- navigate to: \(destination.rawValue)")
            switch destination {
            case .Organizations:
                self.pushProcessController(type: OrganizationListProcessController.self)
                
            case .Events:
                self.pushProcessController(type: EventListProcessController.self)
                
            case .Facilities:
                let _ = 7
                
            case .Travel:
                let _ = 7
                
            case .News:
                let _ = 7
                
            case .Inbox:
                let _ = 7
                
            case .Profile:
                // temp for testing
                self.shared.userModelController.logout()
                self.pushProcessController(type: AuthenticationProcessController.self)
            }

        case .eventSelected(let event):
            let eventDetailProcessController = EventDetailProcessController()
            eventDetailProcessController.setup(responseDelegate: self, navController: self.navController, services: self.shared)
            eventDetailProcessController.filter = EntityDescriptor(event)
            eventDetailProcessController.launch()
            self.processControllerStack.append(eventDetailProcessController)
            
        case .organizationSelected(let organization):
            _ = organization.entityID
        }
    }

    
    // MARK: - process controller handling
    
    private func pushProcessController<T> (type: T.Type) where T: ProcessController{
        let processController = T.init()
        processController.setup(responseDelegate: self, navController: self.navController, services: self.shared)
        processController.launch()
        self.processControllerStack.append(processController as ProcessController)
    }
    

    // MARK: - model controller & services handling

    private func loadRegionalResourceModelController (online: Bool) {
        if (self.shared.regionalResourcesModelController == nil) {
            self.shared.regionalResourcesModelController = RegionalResourcesModelController(atLocation: self.shared.userModelController.locationProfile, isOnline: online)
            self.shared.regionalResourcesModelController?.initiateLoading()
        }
        precondition(self.shared.regionalResourcesModelController != nil)
    }
    
    private func loadUserModelController () {
        if (self.shared.userModelController == nil) {
            self.shared.userModelController = UserModelController()
        }
        precondition(self.shared.userModelController != nil)
    }
    
    private func loadConnectivityService () {
        if (self.shared.connectivityService == nil) {
            self.shared.connectivityService = ConnectivityService()
        }
        precondition(self.shared.connectivityService != nil)
    }
    

    // MARK: - db Utilities

    override func checkDatabaseRefresh() {
        self.shared.regionalResourcesModelController?.checkRepositoryUpdate()
    }
    
}
