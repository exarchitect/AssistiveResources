//
//  AssistiveAppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/18/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

// MARK: -TO DO LIST-
// TODO: Organization Detail
// TODO: Filter for OrganizationList
// TODO: Refactor Command Objects
// TODO: User Login
// TODO: CocoaLumberjack
// TODO: Unit Tests for models
// TODO: UI Unit Tests -


struct SharedServices {
    var regionalResources: RegionalResourcesModelController?
    var userModel: User
    var selections: SelectionState
    var connectivityService: ConnectivityService
    init?() {
        userModel = User()
        selections = SelectionState()
        connectivityService = ConnectivityService()
//        guard ? else {
//            return nil
//        }
    }

    mutating func loadRepository() {
        guard regionalResources == nil else {
            return
        }
        let online = true       // TODO: implement
        let repository = RegionalResourcesModelController(atLocation: userModel.locationProfile, isOnline: online)
        repository.initiateLoading()
        regionalResources = repository
    }
}

struct SelectionState {
    private var identifierDictionary: [String:Int] = [:]
    static var organizationKey: String {
        "organization_key"
    }
    static var eventKey: String {
        "event_key"
    }
    var currentOrganization: Int? {
        get {
            identifierDictionary[SelectionState.organizationKey]
        }
        set {
            guard let newValue = newValue else {
                return
            }
            identifierDictionary.updateValue(newValue, forKey: SelectionState.organizationKey)
        }
    }
    var currentEvent: Int? {
        get {
            identifierDictionary[SelectionState.eventKey]
        }
        set {
            guard let newValue = newValue else {
                return
            }
            identifierDictionary.updateValue(newValue, forKey: SelectionState.eventKey)
        }
    }
}


class AssistiveAppController: AppController {
    
    var shared: SharedServices? = SharedServices()
    var navigationStack: NavigationStack!

    override init() {
        super.init()
        initializeRemoteDatabase()
    }
    
    
    override func internalStart() {

        guard let sharedServices = shared, let navigationController = navController else {
            return
        }
        
        navigationStack = NavigationStack(services: sharedServices, navController: navigationController)
        navigationStack.launchProcess(NavListProcessController.self, animated: false)

        // temp override to fail login for testing
        sharedServices.userModel.storeUserCredentials(username: "", password: "")
        //self.shared.userModel.storeUserCredentials(username: "exarchitect@gmail.com", password: "alongishpassword")
        
        sharedServices.userModel.validateCredentials(completion: { loginOutcome in
            switch loginOutcome {
            case .authenticated:
                self.navigationStack.execute(command: .userSuccessfullyIdentified)
            case .unknown:
                fallthrough
            case .needCredentials:
                self.navigationStack.execute(command: .requestUserIdentity)
            }
        })
    }
    

    override func checkDatabaseRefresh() {
        shared?.regionalResources?.checkRepositoryUpdate()
    }
    
}
