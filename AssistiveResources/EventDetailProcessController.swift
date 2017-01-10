//
//  EventDetailProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/13/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol EventDetailProcessControllerResponseProtocol: ProcessControllerProtocol {
    func notifyShowOrganizationDetail (org: EntityDescriptor)
}


class EventDetailProcessController: ProcessController, EventDetailViewControllerResponseProtocol {

    weak private var eventDetailDelegate: EventDetailProcessControllerResponseProtocol!
    unowned private var rsrcModelController: RegionalResourcesModelController
    private var eventDetailViewController: EventDetailViewController!
    
    init(rsrcsModelController: RegionalResourcesModelController, eventDetailProcessMessageDelegate: EventDetailProcessControllerResponseProtocol) {
        self.eventDetailDelegate = eventDetailProcessMessageDelegate
        self.rsrcModelController = rsrcsModelController
    }
    
    func launch() -> Bool {
        
        self.eventDetailViewController = instantiateViewController(storyboardName: "EventDetailStoryboard", storyboardID: "EventDetailStoryboardID") as! EventDetailViewController
        self.eventDetailViewController.dependencies(resources: self.rsrcModelController, selectorDelegate: self)
        //self.eventDetailViewController.dependencies(selectorDelegate: self)
        
        let navCtrller = self.eventDetailDelegate.navigationController()
        navCtrller.pushViewController(self.eventDetailViewController, animated: true)
        
        return (self.eventDetailViewController != nil)
    }
    
    override func terminate () {
        super.terminate()

        let navCtrller = self.eventDetailDelegate.navigationController()
        let _ = navCtrller.popViewController(animated: true)
        self.eventDetailViewController = nil
    }
    
    deinit {
        print("deallocating eventdetailPC")
    }
    
    // EventDetailViewControllerResponseProtocol
    
    func organizationSelected (evt: EntityDescriptor) {
        self.eventDetailDelegate.notifyShowOrganizationDetail(org: evt)
    }
    
    func backButtonTapped () {
        self.eventDetailDelegate.dismissProcessController(controller: self)
    }

}
