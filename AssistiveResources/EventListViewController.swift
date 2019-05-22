//
//  EventListViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit



class EventListViewController: ProcessViewController, EventListContainerNotificationProtocol, EventFilterResponseProtocol {

    @IBOutlet weak var headerView: HeaderView!
    
    weak private var resourcesModelController:RegionalResourcesModelController?
    var filterViewController:EventFilterViewController?
    weak private var containerViewController:EventContainerViewController?
    var filter: FilterProfile = FilterProfile()
    
    func configuration(resources: RegionalResourcesModelController) {
        self.resourcesModelController = resources

        //filter.developmentalAgeValue = .PreschoolDevelopmentalAge
        filter.proximityValue = .twentyFiveMiles
        filter.ageValue = Age(years: 21)
}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(self.resourcesModelController != nil)
        self.headerView.titleLabel.text = "Upcoming Events"
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //freeMemory()
    }
    
    deinit {
        let _ = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //weak var containerViewController: EventContainerViewController?
        
        if segue.identifier == "EventContainerSegueID" {
            containerViewController = segue.destination as? EventContainerViewController
            containerViewController?.configuration(rsrcModelController: resourcesModelController!, delegate: self, filter: self.filter)
            //containerViewController?.setFilterDescription(desrc: filter.naturalLanguageText())
        }
        
    }

    //MARK:- @IBAction

    @IBAction func backButtonAction(_ sender: Any) {
        self.requestAction(command: AssistiveCommand(type: .dismissTopProcessController))
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        self.notifyFilterSelected()
    }
    
    //MARK: - EventListContainerNotificationProtocol delegate
    
    func notifyRowDetailSelected(rowIndex: Int) {
        self.requestAction(command: AssistiveCommand(type: .eventSelected(event: (entityName: "TestEvent", entityID: 3))))
    }
    
    func notifyFilterSelected() {

        let filterViewController:EventFilterViewController? = instantiateViewController(storyboardName: "EventList", storyboardID: "filterStoryboardID")
        
        filterViewController?.configuration(resources: self.resourcesModelController!, selectorDelegate: self, filter: filter)

        if let filterVC = filterViewController {
            present(filterVC, animated: true, completion: nil)
            self.filterViewController = filterVC
        }
    }
    
    //MARK: - EventFilterResponseProtocol delegate

    func okFilterButtonAction(filter:FilterProfile) {
        self.filter = filter
        if let container = containerViewController {
            container.setFilter(fltr: self.filter)
        }
        self.dismiss(animated: true, completion: nil)
        self.filterViewController = nil
    }
    
    func cancelFilterButtonAction() {
        self.dismiss(animated: true, completion: nil)
        self.filterViewController = nil
    }
    
}

