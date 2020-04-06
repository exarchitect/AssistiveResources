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
// TODO: Refactor Command Objects
// TODO: User Login
// TODO: CocoaLumberjack
// TODO: Unit Tests for models
// TODO: UI Unit Tests -


struct SharedServices: RegionalResourcesProvider, UserProvider {
    var regionalResourcesModelController: RegionalResourcesModelController!
    var userModel: User!
    var connectivityService: ConnectivityService!
}


class AssistiveAppController: AppController, CommandResponseProtocol {
    
    var shared: SharedServices = SharedServices()
    //var commandLog = [AssistiveCommand]()

    override init() {
        super.init()
        initializeRemoteDatabase()
    }
    
    
    override func internalStart() {

        loadUserModel()        // other model controllers not called until after login
        loadConnectivityService()
        
        self.startProcessController(type: NavListProcessController.self)

        // temp override to fail login for testing
        //self.shared.userModel.storeUserCredentials(username: "", password: "")
        //self.shared.userModel.storeUserCredentials(username: "exarchitect@gmail.com", password: "alongishpassword")
        
        self.shared.userModel.validateCredentials(completion: { loginOutcome in
            switch loginOutcome {
            case .Authenticated:
                self.invokeAction(command: AssistiveCommand(type: .userSuccessfullyIdentified))
            case .Unknown:
                fallthrough
            case .NeedCredentials:
                self.invokeAction(command: AssistiveCommand(type: .requestUserIdentity))
            }
        })
    }
    
    
    // MARK: - CommandResponseProtocol
    
    func invokeAction(command: AssistiveCommand) {

        switch command.type {
            
        case .dismissTopProcessController:
            guard let pController = self.processControllerStack.last else {
                return
            }
            pController.terminate()
            let _ = self.processControllerStack.popLast()

        case .requestUserIdentity:
            self.startProcessController(type: AuthenticationProcessController.self)

        case .userSuccessfullyIdentified:
            self.loadRegionalResourceModelController(online: true)
            requestMainNavigationRefresh()

        case .navigateTo(let destination):
            //print(" -- navigate to: \(destination.rawValue)")
            switch destination {
            case .Organizations:
                self.startProcessController(type: OrganizationListProcessController.self)
                
            case .Events:
                self.startProcessController(type: EventListProcessController.self)
                
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
                self.shared.userModel.logout()
                self.startProcessController(type: AuthenticationProcessController.self)
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
    
    private func startProcessController<T> (type: T.Type) where T: ProcessController{
        let processController = T.init()
        processController.setup(responseDelegate: self, navController: self.navController, services: self.shared)
        processController.launch()
        self.processControllerStack.append(processController as ProcessController)
    }
    

    // MARK: - model controller & services handling

    private func loadRegionalResourceModelController (online: Bool) {
        if (self.shared.regionalResourcesModelController == nil) {
            self.shared.regionalResourcesModelController = RegionalResourcesModelController(atLocation: self.shared.userModel.locationProfile, isOnline: online)
            self.shared.regionalResourcesModelController?.initiateLoading()     // TODO: get rid of this
        }
        precondition(self.shared.regionalResourcesModelController != nil)
    }
    
    private func loadUserModel () {
        if (self.shared.userModel == nil) {
            self.shared.userModel = User()
        }
        precondition(self.shared.userModel != nil)
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
