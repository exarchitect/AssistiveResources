//
//  EventListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventListProcessController: ProcessController, EventListViewControllerResponseProtocol {
    
    typealias ExternalDependencies = RegionalResourcesProvider
    
    private let dependencies: ExternalDependencies
    private var eventListViewController: EventListViewController!
    
    init(responseDelegate: ProcessControllerResponseHandler, dependencies: ExternalDependencies) {
        self.dependencies = dependencies
        super.init(responseDelegate: responseDelegate)
    }

    override func launch(navController: UINavigationController) -> Bool {
        
        self.eventListViewController = instantiateViewController(storyboardName: "EventList", storyboardID: "EventListStoryboardID") as! EventListViewController

        self.eventListViewController.configuration(resources: self.dependencies.regionalResourcesModelController, selectorDelegate: self)
        
//        let navCtrller = self.responseDelegate.navigationController()
//        navCtrller.pushViewController(self.eventListViewController, animated: true)
        navController.pushViewController(self.eventListViewController, animated: true)

        return (self.eventListViewController != nil)
    }
    
    override func terminate (navController: UINavigationController) {
        super.terminate(navController: navController)

//        let navCtrller = self.responseDelegate.navigationController()
//        let _ = navCtrller.popViewController(animated: true)
        let _ = navController.popViewController(animated: true)

        self.eventListViewController = nil
    }
    
    
    //MARK: debug
    deinit {
        print("deallocating EventListPC")
    }
    
    
    // EventListViewControllerResponseProtocol
    
    func eventSelected (evt: EntityDescriptor) {
        
        //let cmd = Command(type: .eventSelected(event: evt))
        self.responseDelegate.requestAction(command: Command(type: .eventSelected(event: evt)))
    }

    func backButtonTapped () {

        let cmd = Command(type: .dismissProcessController(controller: self))
        self.responseDelegate.requestAction(command: cmd)
    }

}
