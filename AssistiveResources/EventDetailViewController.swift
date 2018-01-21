//
//  EventDetailViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/14/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventDetailViewController: UIViewController {

    weak private var resourcesModelController: RegionalResourcesModelController?
    private var completionProtocol: ProcessControllerResponseProtocol!

    @IBOutlet weak var scrollView: UIScrollView!
    
    func configuration(resources: RegionalResourcesModelController, selectorDelegate: ProcessControllerResponseProtocol) {
        self.completionProtocol = selectorDelegate
        self.resourcesModelController = resources
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(self.resourcesModelController != nil)
        precondition(self.completionProtocol != nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deallocating eventdetailVC")
    }
    
    @IBAction func evntDetailBackButtonAction(_ sender: Any) {
//        self.completionProtocol.backButtonTapped()
        self.completionProtocol.requestAction(command: AssistiveCommand(type: .dismissTopProcessController))
    }

    @IBAction func orgSelectedButtonAction(_ sender: Any) {
//        self.completionProtocol.organizationSelected(evt: ("",0))
        self.completionProtocol.requestAction(command: AssistiveCommand(type: .eventSelected(event: (entityName: "test", entityID: 1))))
    }

}
