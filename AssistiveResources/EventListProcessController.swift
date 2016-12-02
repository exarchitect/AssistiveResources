//
//  EventListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventListProcessController: NSObject, EventSelectorProtocol {
    
    private var selectorDelegate: EventSelectorProtocol!
    private var rsrcModelController: ResourcesModelController!
    
    private var eventListViewController: EventListViewController!
    private var navCtrller: UINavigationController?
    
    override init() {
        
        // init ?
        
        super.init()
    }
    
    func launch(rsrcsModelController: ResourcesModelController, eventSelectorDelegate: EventSelectorProtocol, navController: UINavigationController) -> Bool {
        
        self.selectorDelegate = eventSelectorDelegate
        self.rsrcModelController = rsrcsModelController
        self.navCtrller = navController
        
        let eventStoryboard: UIStoryboard? = UIStoryboard(name: "EventList", bundle: nil)
        self.eventListViewController = eventStoryboard?.instantiateViewController(withIdentifier: "EventListStoryboardID") as! EventListViewController
        self.eventListViewController.setup(resources: rsrcsModelController, selectorDelegate: self)
        
        navController.pushViewController(self.eventListViewController, animated: true)
        
        return (eventStoryboard != nil && self.eventListViewController != nil)
    }
    
    func teardown () {
        let _ = self.navCtrller?.popViewController(animated: true)
    }
    
    // NavigationSelectorProtocol
    func selectedEvent (selection: Int) {
        
    }
    
}
