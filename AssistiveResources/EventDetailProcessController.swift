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

    private var eventDetailDelegate: EventDetailProcessControllerResponseProtocol!
    private var rsrcModelController: ResourcesModelController!
    private var eventDetailViewController: EventDetailViewController!
    
    override init() {
        // init ?
        super.init()
    }
    
    func dependencies(rsrcsModelController: ResourcesModelController, eventDetailProcessMessageDelegate: EventDetailProcessControllerResponseProtocol) {
        
        self.eventDetailDelegate = eventDetailProcessMessageDelegate
        self.rsrcModelController = rsrcsModelController
    }
    
    func launch() -> Bool {
        
        self.eventDetailViewController = instantiateViewController(storyboardName: "EventDetailStoryboard", storyboardID: "EventDetailStoryboardID") as! EventDetailViewController
        self.eventDetailViewController.dependencies(resources: self.rsrcModelController, selectorDelegate: self)
        
        let navCtrller = self.eventDetailDelegate.navigationController()
        navCtrller.pushViewController(self.eventDetailViewController, animated: true)
        
        return (self.eventDetailViewController != nil)
    }
    
    override func terminate () {
        super.terminate()

        let navCtrller = self.eventDetailDelegate.navigationController()
        let _ = navCtrller.popViewController(animated: true)
    }
    
    // EventDetailViewControllerResponseProtocol
    
    func selectedEvent (evt: EntityDescriptor) {
        self.eventDetailDelegate.notifyShowOrganizationDetail(org: evt)
    }
    
    func backButtonTapped () {
        self.eventDetailDelegate.dismissProcessController(controller: self)
    }

}
