//
//  OrganizationListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/4/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

class OrganizationListProcessController: ProcessController {
    
//    typealias ExternalDependencies = RegionalResourcesProvider
//    
//    private let dependencies: ExternalDependencies
//    
//    init(responseDelegate: ProcessControllerResponseProtocol, navigationController: UINavigationController, dependencies: ExternalDependencies) {
//        self.dependencies = dependencies
//        super.init(responseDelegate: responseDelegate, navController: navigationController)
//    }
//    
    
    override func createViewController() -> UIViewController {
        var organizationListViewController: OrganizationListViewController
        
        organizationListViewController = instantiateViewController(storyboardName: "OrganizationList", storyboardID: "OrganizationListStoryboardID") as! OrganizationListViewController
        organizationListViewController.configuration(resources: self.sharedServices.regionalResourcesModelController, selectorDelegate: self.responseDelegate)
        
        return organizationListViewController
    }
    
    
    //MARK: - debug
    deinit {
        print("deallocating OrganizationListPC")
    }
    

}
