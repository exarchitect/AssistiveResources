//
//  EventListViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol EventListViewControllerResponseProtocol: class {
    func eventSelected (evt: EntityDescriptor)
    func backButtonTapped ()
}


class EventListViewController: UIViewController, EventListContainerNotificationProtocol, EventFilterViewControllerResponseProtocol {

    @IBOutlet weak var headerView: HeaderView!
    
    weak private var selectorDelegate:EventListViewControllerResponseProtocol!
    weak private var resourcesModelController:RegionalResourcesModelController?
    //private var filterViewController:EventFilterViewController?
    
    func configuration(resources: RegionalResourcesModelController, selectorDelegate: EventListViewControllerResponseProtocol) {
        self.selectorDelegate = selectorDelegate
        self.resourcesModelController = resources
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(self.selectorDelegate != nil)
        precondition(self.resourcesModelController != nil)
        self.headerView.titleLabel.text = "Upcoming Events"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //freeMemory()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        weak var containerViewController: EventContainerViewController?
        
        if segue.identifier == "EventContainerSegueID" {
            containerViewController = segue.destination as? EventContainerViewController
            containerViewController?.configuration(rsrcModelController: resourcesModelController!, delegate: self)
        }
        
    }

    //MARK: @IBAction

    @IBAction func backButtonAction(_ sender: Any) {
        self.selectorDelegate.backButtonTapped()
    }
    
    
    //MARK: delegate
    
    func notifyRowDetailSelected(rowIndex: Int) {
        self.selectorDelegate.eventSelected(evt: EntityDescriptor("",0))
    }
    
    func notifyFilterSelected() {

        unowned var filterViewController:EventFilterViewController

        filterViewController = (instantiateViewController(storyboardName: "EventList", storyboardID: "filterStoryboardID") as? EventFilterViewController)!
        filterViewController.configuration(resources: self.resourcesModelController!, selectorDelegate: self)
        
        //guard?
        present(filterViewController, animated: true, completion: nil)
    }
    
    func okFilterButtonAction() {
        self.dismiss(animated: true, completion: nil)
        //self.filterViewController = nil
    }
    
    func cancelFilterButtonAction() {
        self.dismiss(animated: true, completion: nil)
        //self.filterViewController = nil
    }
    
    //MARK: debug
    deinit {
        print("deallocating EventListVC")
    }
    
}

