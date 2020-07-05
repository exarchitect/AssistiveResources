//
//  OrganizationListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/4/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

class OrganizationListProcessController: ProcessController {
    
    override func createPrimaryViewController() -> UIViewController? {
        let primaryViewController = instantiateProcessViewController(storyboardName: "OrganizationList", storyboardID: "OrganizationListStoryboardID")
        primaryViewController?.parentProcessController = self
        return primaryViewController
    }

    //MARK: - debug
    deinit {
        print("deallocating OrganizationListPC")
    }
}
