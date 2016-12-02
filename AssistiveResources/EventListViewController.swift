//
//  EventListViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

protocol EventSelectorProtocol {
    func selectedEvent (selection: Int)
}


class EventListViewController: UIViewController, EventListContainerNotificationProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    //private var tableAdaptor:EventListTableAdaptor!
    private var selectorDelegate:EventSelectorProtocol!
    private var resourcesModelController:ResourcesModelController!
    
    func setup(resources: ResourcesModelController, selectorDelegate: EventSelectorProtocol) {
        self.selectorDelegate = selectorDelegate
        self.resourcesModelController = resources
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableAdaptor = EventListTableAdaptor.init(table: self.tableView, rsrcModelController: self.resourcesModelController, delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var containerViewController: EventContainerViewController?
            if segue.identifier == "EventContainerSegueID" {
                containerViewController = segue.destination as? EventContainerViewController
                containerViewController?.setup(rsrcModelController: resourcesModelController, delegate: self)
            }

    }

    //MARK: @IBAction

    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK: delegate
    
    func notifyRowDetailSelected(rowIndex: Int) {
        
    }
    
    func notifyFilterSelected() {
    
    }
}
