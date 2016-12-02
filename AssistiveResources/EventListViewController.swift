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


class EventListViewController: UIViewController, EventListTableAdaptorNotificationProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    private var tableAdaptor:EventListTableAdaptor!
    private var selectorDelegate:EventSelectorProtocol!
    private var resourcesModelController:ResourcesModelController!
    
    func setup(resources: ResourcesModelController, selectorDelegate: EventSelectorProtocol) {
        self.selectorDelegate = selectorDelegate
        self.resourcesModelController = resources
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableAdaptor = EventListTableAdaptor.init(table: self.tableView, rsrcModelController: self.resourcesModelController, delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: tableView delegate
    
    func notifyRowSelected(rowIndex: Int) {
        
    }
    
    func notifyRowDeleted(rowIndex: Int) {
        
    }
}
