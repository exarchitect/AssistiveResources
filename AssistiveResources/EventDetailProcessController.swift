//
//  EventDetailProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/13/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventDetailProcessController: ProcessController {

    override func createViewController() -> ProcessViewController? {
        let eventDetailViewController: EventDetailViewController? = instantiateViewController(storyboardName: "EventDetailStoryboard", storyboardID: "EventDetailStoryboardID")
        eventDetailViewController?.configuration(resources: self.sharedServices.regionalResourcesModelController)
        
        return eventDetailViewController
    }

    deinit {
        print("deallocating eventdetailPC")
    }
    
}
