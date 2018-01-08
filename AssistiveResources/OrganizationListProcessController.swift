//
//  OrganizationListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/4/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

class OrganizationListProcessController: ProcessController, OrganizationListViewControllerResponseProtocol {
    
    typealias ExternalDependencies = RegionalResourcesProvider
    
    private let dependencies: ExternalDependencies
    private var organizationListViewController: OrganizationListViewController!
    
    init(responseDelegate: ProcessControllerResponseHandler, dependencies: ExternalDependencies) {
        self.dependencies = dependencies
        super.init(responseDelegate: responseDelegate)
    }
    
    override func launch(navController: UINavigationController) -> Bool {
        
        self.organizationListViewController = instantiateViewController(storyboardName: "OrganizationList", storyboardID: "OrganizationListStoryboardID") as! OrganizationListViewController
        self.organizationListViewController.configuration(resources: self.dependencies.regionalResourcesModelController, selectorDelegate: self)
        
        navController.pushViewController(self.organizationListViewController, animated: true)

        return (self.organizationListViewController != nil)
    }
    
    override func terminate (navController: UINavigationController) {
        super.terminate(navController: navController)
        
        let _ = navController.popViewController(animated: true)

        self.organizationListViewController = nil
    }
    
    
    //MARK: debug
    deinit {
        print("deallocating OrganizationListPC")
    }
    
    
    // OrganizationListViewControllerResponseProtocol
    
    func organizationSelected (org: EntityDescriptor) {
        
        self.responseDelegate.requestAction(command: Command(type: .organizationSelected(organization: org)))
    }
    
    func backButtonTapped () {
        
        self.responseDelegate.requestAction(command: Command(type: .dismissProcessController(controller: self)))
    }
    
}
