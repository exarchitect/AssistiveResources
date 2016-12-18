//
//  EventDetailViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/14/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol EventDetailViewControllerResponseProtocol {
    func eventSelected (evt: EntityDescriptor)
    func backButtonTapped ()
}


class EventDetailViewController: UIViewController {

    private var resourcesModelController: ResourcesModelController!
    private var completionProtocol: EventDetailViewControllerResponseProtocol!

    func dependencies(resources: ResourcesModelController, selectorDelegate: EventDetailViewControllerResponseProtocol) {
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
    
    @IBAction func evtDetailBackButtonAction(_ sender: Any) {
        self.completionProtocol.backButtonTapped()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
