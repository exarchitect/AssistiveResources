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
//        return instantiateProcessViewController(storyboardName: "OrganizationList", storyboardID: "OrganizationListStoryboardID")
        let primaryViewController = instantiateProcessViewController(storyboardName: "OrganizationList", storyboardID: "OrganizationListStoryboardID")
        primaryViewController?.parentProcessController = self
        return primaryViewController
    }

    //MARK: - debug
    deinit {
        let _ = 0
        print("deallocating OrganizationListPC")
    }
    

}
