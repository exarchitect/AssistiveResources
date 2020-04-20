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
    
    var filterViewController:EventFilterViewController?
    weak private var containerViewController:EventContainerViewController?
    var filterDict = FilterDictionary()
    var resourcesModelController: RegionalResourcesModelController? {
        return processController?.sharedServices.regionalResourcesModelController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFilter()
        headerView.titleLabel.text = "Upcoming Events"
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //freeMemory()
    }
    
    deinit {
        let _ = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let rsrcsModelController = resourcesModelController else {
            return
        }
        
        if segue.identifier == "EventContainerSegueID" {
            containerViewController = segue.destination as? EventContainerViewController
            containerViewController?.configuration(rsrcModelController: rsrcsModelController, delegate: self)
        }
        
    }

    //MARK:- @IBAction

    @IBAction func backButtonAction(_ sender: Any) {
        processController?.executeCommand(.dismissCurrentProcess)
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        notifyFilterSelected()
    }

    //MARK:- Utilities

    func setupFilter() {
        filterDict[ProximityFilter.key] = ProximityFilter(range: .twentyFiveMiles)
        filterDict[AgeFilter.key] = AgeFilter(monthOfBirth: 4, yearOfBirth: 1994)
        filterDict[DiagnosisFilter.key] = DiagnosisFilter(diagnoses: [.spinaBifida])
        filterDict[MobilityFilter.key] = MobilityFilter(mobilityLimit: .walksWithAid)
        
        containerViewController?.setFilter(fltr: filterDict)
    }

    //MARK: - EventListContainerNotificationProtocol delegate
    
    func notifyRowDetailSelected(rowIndex: Int) {
        let testEvent = EventDescriptor(name: "TestEvent", identifier: 3)
        processController?.executeCommand(.selectEvent(testEvent))
    }
    
    func notifyFilterSelected() {

        let filterViewController: EventFilterViewController? = instantiateViewController(storyboardName: "EventList", storyboardID: "filterStoryboardID")
        if let filterVwCtl = filterViewController {
            filterVwCtl.configuration(resources: resourcesModelController, selectorDelegate: self, filter: filterDict)
            present(filterVwCtl, animated: true, completion: nil)
            self.filterViewController = filterVwCtl
        }
    }
    
    //MARK: - EventFilterResponseProtocol delegate

    func okFilterButtonAction(filter:FilterDictionary) {
        filterDict = filter
        if let container = containerViewController {
            container.setFilter(fltr: filter)
        }
        dismiss(animated: true, completion: nil)
        filterViewController = nil
    }
    
    func cancelFilterButtonAction() {
        dismiss(animated: true, completion: nil)
        filterViewController = nil
    }
    
}

