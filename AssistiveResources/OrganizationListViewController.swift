//
//  OrganizationListViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/4/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


class OrganizationListViewController: ProcessViewController, OrganizationListContainerNotificationProtocol {

    @IBOutlet weak var headerView: HeaderView!
    
    //private var filterViewController:OrganizationFilterViewController?
    var resourcesModelController: RegionalResourcesModelController? {
        return processController?.sharedServices.regionalResourcesModelController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.titleLabel.text = "Organizations & Services"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //freeMemory()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let rsrcModelController = resourcesModelController else {
            return
        }
        if segue.identifier == "OrganizationContainerSegueID" {
            let containerViewController = segue.destination as? OrganizationContainerViewController
            containerViewController?.configuration(rsrcModelController: rsrcModelController, delegate: self)
        }
    }

    //MARK: delegate
    
    func notifyRowDetailSelected(rowIndex: Int) {
        let testOrg = OrganizationDescriptor(name: "TestOrg", identifier: 2)
        processController?.executeCommand(.selectOrganization(testOrg))
    }
    
    func notifyFilterSelected() {
//        unowned var filterViewController:EventFilterViewController
//        filterViewController = (instantiateViewController(storyboardName: "EventList", storyboardID: "filterStoryboardID") as? EventFilterViewController)!
//        filterViewController.dependencies(resources: self.resourcesModelController!, selectorDelegate: self)
//        //guard?
//        present(filterViewController, animated: true, completion: nil)
    }
    
    
    //MARK: @IBAction
    
    @IBAction func backButtonAction(_ sender: Any) {
        processController?.executeCommand(.dismissCurrentProcess)
    }
    
}
