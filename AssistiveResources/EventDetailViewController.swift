//
//  EventDetailViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/14/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventDetailViewController: ProcessViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var resourcesModelController: RegionalResourcesModelController? {
        return parentProcessController?.sharedServices.regionalResourcesModelController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deallocating eventdetailVC")
    }
    
    @IBAction func evntDetailBackButtonAction(_ sender: Any) {
        parentProcessController?.executeCommand(.dismissCurrentProcess)
    }

    @IBAction func orgSelectedButtonAction(_ sender: Any) {
        let testOrg = OrganizationDescriptor(name: "test", identifier: 1)
        parentProcessController?.executeCommand(.showOrganizationDetail(testOrg))
    }

}
