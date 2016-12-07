//
//  EventListViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

protocol EventListViewControllerResponseProtocol {
    //func selectedEvent (selection: Int)
    func backButtonTapped ()
}


class EventListViewController: UIViewController, EventListContainerNotificationProtocol, EventFilterViewControllerResponseProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    //private var tableAdaptor:EventListTableAdaptor!
    private var selectorDelegate:EventListViewControllerResponseProtocol!
    private var resourcesModelController:ResourcesModelController!
    private var filterViewController:EventFilterViewController?
    
    func setup(resources: ResourcesModelController, selectorDelegate: EventListViewControllerResponseProtocol) {
        self.selectorDelegate = selectorDelegate
        self.resourcesModelController = resources
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableAdaptor = EventListTableAdaptor.init(table: self.tableView, rsrcModelController: self.resourcesModelController, delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        freeMemory()
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
        //_ = self.navigationController?.popViewController(animated: true)
        self.selectorDelegate.backButtonTapped()
    }
    
    
    
    //MARK: delegate
    
    func notifyRowDetailSelected(rowIndex: Int) {
        let _ = 4
    }
    
    func notifyFilterSelected() {
        self.filterViewController = instantiateViewController(storyboardName: "EventList", storyboardID: "filterStoryboardID") as? EventFilterViewController
        self.filterViewController?.setup(resources: self.resourcesModelController, selectorDelegate: self)
        //guard
        self.present(self.filterViewController!, animated: true, completion: nil)

    }
    
    func okFilterButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelFilterButtonAction() {
        
    }
    
}
