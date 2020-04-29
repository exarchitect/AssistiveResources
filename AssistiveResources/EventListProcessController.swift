//
//  EventListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventListProcessController: ProcessController {
    
    override func createPrimaryViewController() -> UIViewController? {
        let primaryViewController = instantiateProcessViewController(storyboardName: "EventList", storyboardID: "EventListStoryboardID")
        primaryViewController?.parentProcessController = self
        return primaryViewController
    }

    //MARK: - debug
    deinit {
        let _ = 0
        print("deallocating EventListPC")
    }
    
}
