//
//  OrganizationListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/4/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

class OrganizationListProcessController: ProcessController, OrganizationListViewControllerResponseProtocol {
    
    private var responseDelegate: ProcessControllerProtocol!
    unowned private var rsrcModelController: RegionalResourcesModelController
    private var organizationListViewController: OrganizationListViewController!
    
    init(rsrcsModelController: RegionalResourcesModelController, responseDelegate: ProcessControllerProtocol) {
        self.responseDelegate = responseDelegate
        self.rsrcModelController = rsrcsModelController
    }
    
    override func launch() -> Bool {
        
        self.organizationListViewController = instantiateViewController(storyboardName: "OrganizationList", storyboardID: "OrganizationListStoryboardID") as! OrganizationListViewController
        self.organizationListViewController.dependencies(resources: self.rsrcModelController, selectorDelegate: self)
        
        let navCtrller = self.responseDelegate.navigationController()
        navCtrller.pushViewController(self.organizationListViewController, animated: true)
        
        return (self.organizationListViewController != nil)
    }
    
    override func terminate () {
        super.terminate()
        
        let navCtrller = self.responseDelegate.navigationController()
        let _ = navCtrller.popViewController(animated: true)
        
        self.organizationListViewController = nil
    }
    
    
    //MARK: debug
    deinit {
        print("deallocating OrganizationListPC")
    }
    
    
    // OrganizationListViewControllerResponseProtocol
    
    func organizationSelected (org: EntityDescriptor) {
        
        let cmd = Command(type: .organizationSelected(organization: (entityName: org.entityName, entityID: org.entityID)))
        self.responseDelegate.requestAction(command: cmd)
    }
    
    func backButtonTapped () {
        
        let cmd = Command(type: .dismissCaller(controller: self))
        self.responseDelegate.requestAction(command: cmd)
    }
    
}
