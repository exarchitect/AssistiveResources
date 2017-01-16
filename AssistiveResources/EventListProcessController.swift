//
//  EventListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventListProcessController: ProcessController, EventListViewControllerResponseProtocol {
    
    private var responseDelegate: ProcessControllerProtocol!
    unowned private var rsrcModelController: RegionalResourcesModelController
    private var eventListViewController: EventListViewController!
    
    init(rsrcsModelController: RegionalResourcesModelController, responseDelegate: ProcessControllerProtocol) {
        self.responseDelegate = responseDelegate
        self.rsrcModelController = rsrcsModelController
    }

    override func launch() -> Bool {
        
        self.eventListViewController = instantiateViewController(storyboardName: "EventList", storyboardID: "EventListStoryboardID") as! EventListViewController
        self.eventListViewController.dependencies(resources: self.rsrcModelController, selectorDelegate: self)
        
        let navCtrller = self.responseDelegate.navigationController()
        navCtrller.pushViewController(self.eventListViewController, animated: true)
        
        return (self.eventListViewController != nil)
    }
    
    override func terminate () {
        super.terminate()

        let navCtrller = self.responseDelegate.navigationController()
        let _ = navCtrller.popViewController(animated: true)

        self.eventListViewController = nil
    }
    
    
    //MARK: debug
    deinit {
        print("deallocating EventListPC")
    }
    
    
    // EventListViewControllerResponseProtocol
    
    func eventSelected (evt: EntityDescriptor) {
        
        let cmd = Command(type: Command.CommandType.eventSelected(event: evt))
        self.responseDelegate.requestAction(command: cmd)
    }

    func backButtonTapped () {

        let cmd = Command(type: Command.CommandType.dismissCaller(controller: self))
        self.responseDelegate.requestAction(command: cmd)
    }

}
