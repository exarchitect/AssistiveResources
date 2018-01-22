//
//  EventListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventListProcessController: ProcessController {
    
    override func createViewController() -> ProcessViewController? {
        let eventListViewController: EventListViewController? = instantiateViewController(storyboardName: "EventList", storyboardID: "EventListStoryboardID")
        eventListViewController?.configuration(resources: self.sharedServices.regionalResourcesModelController)
        
        return eventListViewController
    }

    //MARK: - debug
    deinit {
        print("deallocating EventListPC")
    }
    
}
