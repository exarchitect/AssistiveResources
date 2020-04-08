//
//  EventDetailProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/13/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventDetailProcessController: ProcessController {

    var filter:EventDescriptor?
    
    override func createPrimaryViewController() -> ProcessViewController? {
        return instantiateProcessViewController(storyboardName: "EventDetailStoryboard", storyboardID: "EventDetailStoryboardID")
    }

    deinit {
        let _ = 0
        //print("deallocating eventdetailPC")
    }
    
}
