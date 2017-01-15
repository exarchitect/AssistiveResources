//
//  EventDetailProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/13/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


//protocol EventDetailProcessControllerResponseProtocol: ProcessControllerProtocol {
//    func notifyShowOrganizationDetail (org: EntityDescriptor)
//}


class EventDetailProcessController: ProcessController, EventDetailViewControllerResponseProtocol {

    weak private var responseDelegate: ProcessControllerProtocol!
    unowned private var rsrcModelController: RegionalResourcesModelController
    private var eventDetailViewController: EventDetailViewController!
    
    init(rsrcsModelController: RegionalResourcesModelController, responseDelegate: ProcessControllerProtocol) {
        self.responseDelegate = responseDelegate
        self.rsrcModelController = rsrcsModelController
    }
    
    func launch() -> Bool {
        
        self.eventDetailViewController = instantiateViewController(storyboardName: "EventDetailStoryboard", storyboardID: "EventDetailStoryboardID") as! EventDetailViewController
        self.eventDetailViewController.dependencies(resources: self.rsrcModelController, selectorDelegate: self)
        //self.eventDetailViewController.dependencies(selectorDelegate: self)
        
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
        //self.eventDetailDelegate.notifyShowOrganizationDetail(org: evt)
        
        let cmd = Command(type: Command.CommandType.eventSelected(event: evt))
        self.responseDelegate.requestAction(command: cmd)
    }
    
    func backButtonTapped () {
        //self.eventDetailDelegate.dismissProcessController(controller: self)
        
        let cmd = Command(type: Command.CommandType.dismissCaller(controller: self))
        self.responseDelegate.requestAction(command: cmd)
    }

}
