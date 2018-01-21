//
//  EventListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventListProcessController: ProcessController {
    
//    typealias ExternalDependencies = RegionalResourcesProvider
//
//    private let dependencies: ExternalDependencies
    
//    init(responseDelegate: ProcessControllerResponseProtocol, navigationController: UINavigationController, services: SharedServices) {
////        self.dependencies = dependencies
//        super.init(responseDelegate: responseDelegate, navController: navigationController, services: services)
//    }

    override func createViewController() -> UIViewController {
        var eventListViewController: EventListViewController
        
        eventListViewController = instantiateViewController(storyboardName: "EventList", storyboardID: "EventListStoryboardID") as! EventListViewController
        eventListViewController.configuration(resources: self.sharedServices.regionalResourcesModelController, selectorDelegate: self.responseDelegate)
        
        return eventListViewController
    }
    

    //MARK: - debug
    deinit {
        print("deallocating EventListPC")
    }
    
}
