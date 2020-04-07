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


class AssistiveAppController: AppController {
    
    var shared: SharedServices = SharedServices()
    var navigationStack: NavigationStack!

    override init() {
        super.init()
        initializeRemoteDatabase()
    }
    
    
    override func internalStart() {

        loadUserModel()        // other model controllers not called until after login
        loadConnectivityService()
        
        navigationStack = NavigationStack(services: shared, navController: self.navController)
        navigationStack.instantiateProcess(ofType: NavListProcessController.self)

        // temp override to fail login for testing
        self.shared.userModel.storeUserCredentials(username: "", password: "")
        //self.shared.userModel.storeUserCredentials(username: "exarchitect@gmail.com", password: "alongishpassword")
        
        self.shared.userModel.validateCredentials(completion: { loginOutcome in
            switch loginOutcome {
            case .Authenticated:
                self.navigationStack.invokeAction(command: AssistiveCommand(type: .userSuccessfullyIdentified))
            case .Unknown:
                fallthrough
            case .NeedCredentials:
                self.navigationStack.invokeAction(command: AssistiveCommand(type: .requestUserIdentity))
            }
        })
    }
    
    
    // MARK: - model controller & services handling

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
