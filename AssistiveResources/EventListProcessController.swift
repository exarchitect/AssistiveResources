//
//  EventListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

protocol EventListProcessControllerResponseProtocol: ProcessControllerProtocol {
    func notifyShowEventDetail (evt: EntityDescriptor)
}



class EventListProcessController: ProcessController, EventListViewControllerResponseProtocol {
    
    private var eventDelegate: EventListProcessControllerResponseProtocol!
    private var rsrcModelController: ResourcesModelController!
    
    private var eventListViewController: EventListViewController!
    
    override init() {
        // init ?
        super.init()
    }
    
    func dependencies(rsrcsModelController: ResourcesModelController, eventProcessMessageDelegate: EventListProcessControllerResponseProtocol) {
        
        self.eventDelegate = eventProcessMessageDelegate
        self.rsrcModelController = rsrcsModelController
    }
    
    func launch() -> Bool {
        
        self.eventListViewController = instantiateViewController(storyboardName: "EventList", storyboardID: "EventListStoryboardID") as! EventListViewController
        self.eventListViewController.dependencies(resources: self.rsrcModelController, selectorDelegate: self)
        
        let navCtrller = self.eventDelegate.navigationController()
        navCtrller.pushViewController(self.eventListViewController, animated: true)
        
        return (self.eventListViewController != nil)
    }
    
    override func terminate () {
        super.terminate()

        let navCtrller = self.eventDelegate.navigationController()
        let _ = navCtrller.popViewController(animated: true)
    }
    
    
    // EventListViewControllerResponseProtocol
    
    func eventSelected (evt: EntityDescriptor) {
        self.eventDelegate.notifyShowEventDetail(evt: evt)
    }

    func backButtonTapped () {
        self.eventDelegate.dismissProcessController(controller: self)
    }

}
