//
//  EventDetailProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/13/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol EventDetailProcessControllerResponseProtocol {
    func dismissEventDetailProcessController ()
    func notifyShowOrganizationDetail (org: EntityDescriptor)
}


class EventDetailProcessController: ProcessController, EventDetailViewControllerResponseProtocol {

    private var eventDetailDelegate: EventDetailProcessControllerResponseProtocol!
    private var rsrcModelController: ResourcesModelController!
    private var eventDetailViewController: EventDetailViewController!
    private var navCtrller: UINavigationController?
    
    override init() {
        // init ?
        super.init()
    }
    
    func dependencies(rsrcsModelController: ResourcesModelController, eventDetailProcessMessageDelegate: EventDetailProcessControllerResponseProtocol) {
        
        self.eventDetailDelegate = eventDetailProcessMessageDelegate
        self.rsrcModelController = rsrcsModelController
    }
    
    func launch(navController: UINavigationController) -> Bool {
        
        self.navCtrller = navController
        
        self.eventDetailViewController = instantiateViewController(storyboardName: "EventDetailStoryboard", storyboardID: "EventDetailStoryboardID") as! EventDetailViewController
        self.eventDetailViewController.dependencies(resources: self.rsrcModelController, selectorDelegate: self)
        
        navController.pushViewController(self.eventDetailViewController, animated: true)
        
        return (self.eventDetailViewController != nil)
    }
    
    override func terminate () {
        super.terminate()
        let _ = self.navCtrller?.popViewController(animated: true)
    }
    
    // EventDetailViewControllerResponseProtocol
    
    func selectedEvent (evt: EntityDescriptor) {
        self.eventDetailDelegate.notifyShowOrganizationDetail(org: evt)
    }
    
    func backButtonTapped () {
        self.eventDetailDelegate.dismissEventDetailProcessController()
    }

}
