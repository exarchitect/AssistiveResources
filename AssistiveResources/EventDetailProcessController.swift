//
//  EventDetailProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/13/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventDetailProcessController: ProcessController {

    var event: EventDescriptor?

    override func createPrimaryViewController() -> UIViewController? {
        let primaryViewController = instantiateProcessViewController(storyboardName: "EventDetailStoryboard", storyboardID: "EventDetailStoryboardID")
        primaryViewController?.parentProcessController = self
        return primaryViewController
    }

    deinit {
        print("deallocating eventdetailPC")
    }
}
