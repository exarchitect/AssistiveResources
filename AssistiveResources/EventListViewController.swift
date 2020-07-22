//
//  EventListViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit



class EventListViewController: UIViewController, ViewControllable, EventSelectionNotification, EventFilterResponse {

    weak var parentProcessController: ProcessController?

    @IBOutlet weak var headerView: HeaderView!
    
    var filterViewController:EventFilterViewController?
    weak private var containerViewController:EventContainerViewController?
    var filterDict = FilterDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFilterData()
        headerView.titleLabel.text = "Upcoming Events"
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //freeMemory()
    }
    
    deinit {
        print("deallocating EventListViewController")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let rsrcsModelController = resourcesModel else {
            return
        }
        
        if segue.identifier == "EventContainerSegueID" {
            containerViewController = segue.destination as? EventContainerViewController
            containerViewController?.configuration(rsrcModelController: rsrcsModelController, delegate: self)
        }
        
    }

    //MARK:- @IBAction

    @IBAction func backButtonAction(_ sender: Any) {
        execute(command: .dismissCurrentProcess)
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        modifyEventFilter()
    }

    //MARK:- Utilities

    func setupFilterData() {
        filterDict[ProximityFilter.key] = ProximityFilter(range: .twentyFiveMiles)
        filterDict[AgeFilter.key] = AgeFilter(monthOfBirth: 4, yearOfBirth: 1994)
        filterDict[DiagnosisFilter.key] = DiagnosisFilter(diagnoses: [.spinaBifida])
        filterDict[MobilityFilter.key] = MobilityFilter(mobilityLimit: .walksWithAid)
        
        containerViewController?.setFilter(fltr: filterDict)
    }

    //MARK: - EventSelectionNotification delegate
    
    func showEventDetail(for descriptor: EventDescriptor) {
        execute(command: .showEventDetail(descriptor))
    }
    
    func modifyEventFilter() {

        let filterViewController: EventFilterViewController? = instantiateViewController(storyboardName: "EventList", storyboardID: "filterStoryboardID")
        if let filterVwCtl = filterViewController {
            filterVwCtl.configuration(resources: resourcesModel, selectorDelegate: self, filter: filterDict)
            present(filterVwCtl, animated: true, completion: nil)
            self.filterViewController = filterVwCtl
        }
    }
    
    //MARK: - EventFilterResponse delegate

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
