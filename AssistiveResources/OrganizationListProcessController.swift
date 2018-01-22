//
//  OrganizationListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/4/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

class OrganizationListProcessController: ProcessController {
    
    override func createViewController() -> ProcessViewController? {
        let organizationListViewController: OrganizationListViewController? = instantiateViewController(storyboardName: "OrganizationList", storyboardID: "OrganizationListStoryboardID")
        organizationListViewController?.configuration(resources: self.sharedServices.regionalResourcesModelController)
        
        return organizationListViewController
    }

    //MARK: - debug
    deinit {
        print("deallocating OrganizationListPC")
    }
    

}
