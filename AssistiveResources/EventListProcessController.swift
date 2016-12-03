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



class EventListProcessController: ProcessController, EventSelectorProtocol {
    
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
        
        let eventStoryboard: UIStoryboard? = UIStoryboard(name: "EventList", bundle: nil)
        self.eventListViewController = eventStoryboard?.instantiateViewController(withIdentifier: "EventListStoryboardID") as! EventListViewController
        self.eventListViewController.setup(resources: self.rsrcModelController, selectorDelegate: self)
        
        navController.pushViewController(self.eventListViewController, animated: true)
        
        return (eventStoryboard != nil && self.eventListViewController != nil)
    }
    
    override func terminate () {
        super.terminate()
        let _ = self.navCtrller?.popViewController(animated: true)
    }
    
    // EventSelectorProtocol
    func selectedEvent (selection: Int) {
        
    }
    
    func backButtonTapped () {
        self.eventDelegate.dismissEventProcessController()
    }

    func filterButtonTapped () {
        
    }

}
