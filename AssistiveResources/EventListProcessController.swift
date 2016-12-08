//
//  EventListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

protocol EventListProcessControllerResponseProtocol {
    func dismissEventProcessController ()
    func notifyOrganizationSelected (org: EntityDescriptor)
}



class EventListProcessController: ProcessController, EventListViewControllerResponseProtocol {
    
    private var eventDelegate: EventListProcessControllerResponseProtocol!
    private var rsrcModelController: ResourcesModelController!
    
    private var eventListViewController: EventListViewController!
    private var navCtrller: UINavigationController?
    
    override init() {
        // init ?
        super.init()
    }
    
    func dependencies(rsrcsModelController: ResourcesModelController, eventProcessMessageDelegate: EventListProcessControllerResponseProtocol) {
        
        self.eventDelegate = eventProcessMessageDelegate
        self.rsrcModelController = rsrcsModelController
    }
    
    func launch(navController: UINavigationController) -> Bool {
        
        //self.eventDelegate = eventProcessMessageDelegate
        //self.rsrcModelController = rsrcsModelController
        self.navCtrller = navController
        
        self.eventListViewController = instantiateViewController(storyboardName: "EventList", storyboardID: "EventListStoryboardID") as! EventListViewController
        self.eventListViewController.dependencies(resources: self.rsrcModelController, selectorDelegate: self)
        
        navController.pushViewController(self.eventListViewController, animated: true)
        
        return (self.eventListViewController != nil)
    }
    
    override func terminate () {
        super.terminate()
        let _ = self.navCtrller?.popViewController(animated: true)
    }
    
    // EventListViewControllerResponseProtocol
    
    func backButtonTapped () {
        self.eventDelegate.dismissEventProcessController()
    }

}
