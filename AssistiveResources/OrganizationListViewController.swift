//
//  OrganizationListViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/4/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


class OrganizationListViewController: UIViewController, ViewControllable, OrganizationListContainerNotificationProtocol {

    weak var parentProcessController: ProcessController?

    @IBOutlet weak var headerView: HeaderView!
    
    //private var filterViewController:OrganizationFilterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.titleLabel.text = "Organizations & Services"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //freeMemory()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let rsrcModelController = resourcesModel else {
            return
        }
        if segue.identifier == "OrganizationContainerSegueID" {
            let containerViewController = segue.destination as? OrganizationContainerViewController
            containerViewController?.configuration(rsrcModelController: rsrcModelController, delegate: self)
        }
    }

    //MARK: delegate
    
    func showOrganizationDetail(for descriptor: OrganizationDescriptor) {
        execute(command: .showOrganizationDetail(descriptor))
    }

    func modifyOrganizationFilter() {
//        let filterViewController: EventFilterViewController? = instantiateViewController(storyboardName: "EventList", storyboardID: "filterStoryboardID")
//        if let filterVwCtl = filterViewController {
//            filterVwCtl.configuration(resources: resourcesModelController, selectorDelegate: self, filter: filterDict)
//            present(filterVwCtl, animated: true, completion: nil)
//            self.filterViewController = filterVwCtl
//}
    }


    //MARK: @IBAction
    
    @IBAction func backButtonAction(_ sender: Any) {
        execute(command: .dismissCurrentProcess)
    }
}
