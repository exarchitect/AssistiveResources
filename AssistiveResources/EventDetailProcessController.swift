//
//  EventDetailProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/13/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventDetailProcessController: ProcessController {

    typealias ExternalDependencies = RegionalResourcesProvider & UserProvider
    
    private let dependencies: ExternalDependencies
    
    init(responseDelegate: ProcessControllerResponseProtocol, navController: UINavigationController, dependencies: ExternalDependencies) {
        self.dependencies = dependencies
        super.init(responseDelegate: responseDelegate, navController: navController)
    }
    
    
    override func createViewController() -> UIViewController {
        var eventDetailViewController: EventDetailViewController
        
        eventDetailViewController = instantiateViewController(storyboardName: "EventDetailStoryboard", storyboardID: "EventDetailStoryboardID") as! EventDetailViewController
        eventDetailViewController.configuration(resources: self.dependencies.regionalResourcesModelController, selectorDelegate: self.responseDelegate)
        
        return eventDetailViewController
    }
    
    deinit {
        print("deallocating eventdetailPC")
    }
    
}
