//
//  OrganizationListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/4/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

class OrganizationListProcessController: ProcessController {
    
    override func createPrimaryViewController() -> ProcessViewController? {
        return instantiateProcessViewController(storyboardName: "OrganizationList", storyboardID: "OrganizationListStoryboardID")
    }

    //MARK: - debug
    deinit {
        let _ = 0
        //print("deallocating OrganizationListPC")
    }
    

}
