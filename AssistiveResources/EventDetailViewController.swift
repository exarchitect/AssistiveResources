//
//  EventDetailViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/14/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventDetailViewController: UIViewController, ViewControllable, CacheUpdateProtocol {

    weak var parentProcessController: ProcessController?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerTextLabel: UILabel!

    private var event: SPNEvent?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedEventID = parentProcessController?.sharedServices.selections.currentEvent else {
            return
        }
        event = uncachedEvent(withIdentifier: selectedEventID)
        headerTextLabel.text = event?.eventTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deallocating eventdetailVC")
    }

    func notifyRepositoryWasUpdated() {
        // TODO
    }
    
    @IBAction func evntDetailBackButtonAction(_ sender: Any) {
        execute(command: .dismissCurrentProcess)
    }

    @IBAction func orgSelectedButtonAction(_ sender: Any) {
        let testOrg = OrganizationDescriptor(name: "test", identifier: 1)
        execute(command: .showOrganizationDetail(testOrg))
    }

}
