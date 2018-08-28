//
//  EventDetailViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/14/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class EventDetailViewController: ProcessViewController {

    weak private var resourcesModelController: RegionalResourcesModelController?
    @IBOutlet weak var scrollView: UIScrollView!
    
    func configuration(resources: RegionalResourcesModelController) {
        self.resourcesModelController = resources
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(self.resourcesModelController != nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        let _ = 0
        //print("deallocating eventdetailVC")
    }
    
    @IBAction func evntDetailBackButtonAction(_ sender: Any) {
        self.requestAction(command: AssistiveCommand(type: .dismissTopProcessController))
    }

    @IBAction func orgSelectedButtonAction(_ sender: Any) {
        self.requestAction(command: AssistiveCommand(type: .eventSelected(event: (entityName: "test", entityID: 1))))
    }

}
