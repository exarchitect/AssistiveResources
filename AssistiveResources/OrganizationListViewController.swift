//
//  OrganizationListViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/4/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol OrganizationListViewControllerResponseProtocol: class {
    func organizationSelected (org: EntityDescriptor)
    func backButtonTapped ()
}


class OrganizationListViewController: UIViewController, OrganizationListContainerNotificationProtocol {

    @IBOutlet weak var headerView: HeaderView!
    
    weak private var selectorDelegate:OrganizationListViewControllerResponseProtocol!
    weak private var resourcesModelController:RegionalResourcesModelController?
    //private var filterViewController:OrganizationFilterViewController?
    
    func dependencies(resources: RegionalResourcesModelController, selectorDelegate: OrganizationListViewControllerResponseProtocol) {
        self.selectorDelegate = selectorDelegate
        self.resourcesModelController = resources
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(self.selectorDelegate != nil)
        precondition(self.resourcesModelController != nil)
        self.headerView.titleLabel.text = "Organizations & Services"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //freeMemory()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        weak var containerViewController: OrganizationContainerViewController?
        
        if segue.identifier == "OrganizationContainerSegueID" {
            containerViewController = segue.destination as? OrganizationContainerViewController
            containerViewController?.dependencies(rsrcModelController: resourcesModelController!, delegate: self)
        }
        
    }

    //MARK: delegate
    
    func notifyRowDetailSelected(rowIndex: Int) {
        self.selectorDelegate.organizationSelected(org: EntityDescriptor("",0))
    }
    
    func notifyFilterSelected() {
//        if (self.resourcesModelController?.events.isLoading())! {
//            return
//        }
//        unowned var filterViewController:EventFilterViewController
//        
//        filterViewController = (instantiateViewController(storyboardName: "EventList", storyboardID: "filterStoryboardID") as? EventFilterViewController)!
//        filterViewController.dependencies(resources: self.resourcesModelController!, selectorDelegate: self)
//        
//        //guard?
//        present(filterViewController, animated: true, completion: nil)
    }
    
    
    //MARK: @IBAction
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.selectorDelegate.backButtonTapped()
    }
    
}
