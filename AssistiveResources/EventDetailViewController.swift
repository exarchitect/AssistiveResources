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
        return processController?.sharedServices.regionalResourcesModelController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
