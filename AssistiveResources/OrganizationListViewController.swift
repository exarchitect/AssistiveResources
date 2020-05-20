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
        return parentProcessController?.sharedServices.regionalResources
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
    
    func notifyDetailSelected(for descriptor: OrganizationDescriptor) {
        execute(command: .showOrganizationDetail(descriptor))
    }

    func notifyFilterSelected() {
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
