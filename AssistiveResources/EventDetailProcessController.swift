//
//  EventDetailProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/13/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventDetailProcessController: ProcessController, EventDetailViewControllerResponseProtocol {

    //weak private var responseDelegate: ProcessControllerProtocol!
    weak private var rsrcModelController: RegionalResourcesModelController!
    private var eventDetailViewController: EventDetailViewController!
    
//    override init(responseDelegate: ProcessControllerProtocol) {
//        super.init(responseDelegate: responseDelegate)
//    }
    
    func modelDependency(rsrcsModelController: RegionalResourcesModelController) {
        self.rsrcModelController = rsrcsModelController
    }
    
    override func launch() -> Bool {
        
        self.eventDetailViewController = instantiateViewController(storyboardName: "EventDetailStoryboard", storyboardID: "EventDetailStoryboardID") as! EventDetailViewController
        self.eventDetailViewController.dependencies(resources: self.rsrcModelController, selectorDelegate: self)
        
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
        
        let cmd = Command(type: .dismissCaller(controller: self))
        self.responseDelegate.requestAction(command: cmd)
    }

}
