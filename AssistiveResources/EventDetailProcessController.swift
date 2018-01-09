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
    
    override func launch() {
        var eventDetailViewController: EventDetailViewController
        
        eventDetailViewController = instantiateViewController(storyboardName: "EventDetailStoryboard", storyboardID: "EventDetailStoryboardID") as! EventDetailViewController
        eventDetailViewController.configuration(resources: self.dependencies.regionalResourcesModelController, selectorDelegate: self.responseDelegate)
        
        self.primaryViewController = eventDetailViewController
        super.launch()
    }
    
    deinit {
        print("deallocating eventdetailPC")
    }
    
//    // EventDetailViewControllerResponseProtocol
//    
//    func organizationSelected (evt: EntityDescriptor) {
//        
//        let cmd = Command(type: .eventSelected(event: evt))
//        self.responseDelegate.requestAction(command: cmd)
//    }
//    
//    func backButtonTapped () {
//        
////        let cmd = Command(type: .dismissProcessController(controller: self))
////        self.responseDelegate.requestAction(command: cmd)
//        self.responseDelegate.requestAction(command: Command(type: .dismissTopProcessController))
//    }

}
