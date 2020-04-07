//
//  EventListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventListProcessController: ProcessController {
    
    override func createPrimaryViewController() -> ProcessViewController? {
        return instantiateProcessViewController(storyboardName: "EventList", storyboardID: "EventListStoryboardID")
    }

    //MARK: - debug
    deinit {
        let _ = 0
        //print("deallocating EventListPC")
    }
    
}
