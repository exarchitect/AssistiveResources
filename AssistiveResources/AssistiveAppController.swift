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


protocol UserProvider {
    var userModel: User { get }
}

protocol RegionalResourcesProvider {
    var regionalResourcesModelController: RegionalResourcesModelController? { get }
}

struct SharedServices: RegionalResourcesProvider, UserProvider {
    var regionalResourcesModelController: RegionalResourcesModelController?
    var userModel: User
    var connectivityService: ConnectivityService
    init?() {
        userModel = User()
        connectivityService = ConnectivityService()
//        guard ? else {
//            return nil
//        }
    }

    mutating func loadRepositoryIfNeeded() {
        guard regionalResourcesModelController == nil else {
            return
        }
        let online = true       // TODO: implement
        let repository = RegionalResourcesModelController(atLocation: userModel.locationProfile, isOnline: online)
        repository.initiateLoading()
        regionalResourcesModelController = repository
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
        navigationStack.launchProcess(ofType: NavListProcessController.self)

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
        shared?.regionalResourcesModelController?.checkRepositoryUpdate()
    }
    
}
