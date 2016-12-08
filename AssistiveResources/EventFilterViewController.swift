//
//  EventFilterViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/5/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol EventFilterViewControllerResponseProtocol {
    //func selectedEvent (selection: Int)
    func okFilterButtonAction ()
    func cancelFilterButtonAction ()
}



class EventFilterViewController: UIViewController {

    private var selectorDelegate:EventFilterViewControllerResponseProtocol!
    private var resourcesModelController:ResourcesModelController!

    func dependencies(resources: ResourcesModelController, selectorDelegate: EventFilterViewControllerResponseProtocol) {
        self.selectorDelegate = selectorDelegate
        self.resourcesModelController = resources
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        precondition(self.selectorDelegate != nil)
        precondition(self.resourcesModelController != nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        self.selectorDelegate.okFilterButtonAction()
    }

    
}
