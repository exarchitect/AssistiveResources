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
    
    init(responseDelegate: ProcessControllerResponseHandler, navigationController: UINavigationController, dependencies: ExternalDependencies) {
        self.dependencies = dependencies
        super.init(responseDelegate: responseDelegate, navController: navigationController)
    }

    override func launch() -> Bool {
        
        self.eventListViewController = instantiateViewController(storyboardName: "EventList", storyboardID: "EventListStoryboardID") as! EventListViewController
        self.eventListViewController.configuration(resources: self.dependencies.regionalResourcesModelController, selectorDelegate: self)
        
        self.navigationController.pushViewController(self.eventListViewController, animated: true)

        return (self.eventListViewController != nil)
    }
    
    override func terminate () {
        super.terminate()

        let _ = self.navigationController.popViewController(animated: true)

        self.eventListViewController = nil
    }
    
    
    //MARK: debug
    deinit {
        print("deallocating EventListPC")
    }
    
    
    // EventListViewControllerResponseProtocol
    
    func eventSelected (evt: EntityDescriptor) {
        
        self.responseDelegate.requestAction(command: Command(type: .eventSelected(event: evt)))
    }

    func backButtonTapped () {

        let cmd = Command(type: .dismissProcessController(controller: self))
        self.responseDelegate.requestAction(command: cmd)
    }

}
