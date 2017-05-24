//
//  EventDetailProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/13/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventDetailProcessController: ProcessController, EventDetailViewControllerResponseProtocol {

    typealias ExternalDependencies = RegionalResourcesProvider & UserProvider
    
    private let dependencies: ExternalDependencies
    private var eventDetailViewController: EventDetailViewController!
    
    init(responseDelegate: ProcessControllerResponseHandler, dependencies: ExternalDependencies) {
        self.dependencies = dependencies
        super.init(responseDelegate: responseDelegate)
    }
    
    override func launch() -> Bool {
        
        self.eventDetailViewController = instantiateViewController(storyboardName: "EventDetailStoryboard", storyboardID: "EventDetailStoryboardID") as! EventDetailViewController
        self.eventDetailViewController.configuration(resources: self.dependencies.regionalResourcesModelController, selectorDelegate: self)
        
        let navCtrller = self.responseDelegate.navigationController()
        navCtrller.pushViewController(self.eventDetailViewController, animated: true)
        
        return (self.eventDetailViewController != nil)
    }
    
    override func terminate () {
        super.terminate()

        let navCtrller = self.responseDelegate.navigationController()
        let _ = navCtrller.popViewController(animated: true)
        self.eventDetailViewController = nil
    }
    
    deinit {
        print("deallocating eventdetailPC")
    }
    
    // EventDetailViewControllerResponseProtocol
    
    func organizationSelected (evt: EntityDescriptor) {
        
        let cmd = Command(type: .eventSelected(event: evt))
        self.responseDelegate.requestAction(command: cmd)
    }
    
    func backButtonTapped () {
        
        let cmd = Command(type: .dismissProcessController(controller: self))
        self.responseDelegate.requestAction(command: cmd)
    }

}
