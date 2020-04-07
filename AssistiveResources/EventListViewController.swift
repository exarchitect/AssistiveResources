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
    var filter: FilterProfile = FilterProfile()
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
            containerViewController?.configuration(rsrcModelController: rsrcsModelController, delegate: self, filter: filter)
            //containerViewController?.setFilterDescription(desrc: filter.naturalLanguageText())
        }
        
    }

    //MARK:- @IBAction

    @IBAction func backButtonAction(_ sender: Any) {
        requestAction(command: AssistiveCommand(type: .dismissTopProcessController))
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        notifyFilterSelected()
    }

    //MARK:- Utilities

    func setupFilter() {
        //filter.developmentalAgeValue = .PreschoolDevelopmentalAge
        filter.proximityValue = .twentyFiveMiles
        filter.ageValue = Age(years: 21)
        //filter.ageValue = Age.notSpecified
    }

    //MARK: - EventListContainerNotificationProtocol delegate
    
    func notifyRowDetailSelected(rowIndex: Int) {
        requestAction(command: AssistiveCommand(type: .eventSelected(event: (entityName: "TestEvent", entityID: 3))))
    }
    
    func notifyFilterSelected() {

        let filterViewController:EventFilterViewController? = instantiateViewController(storyboardName: "EventList", storyboardID: "filterStoryboardID")
        
        filterViewController?.configuration(resources: resourcesModelController, selectorDelegate: self, filter: filter)

        if let filterVC = filterViewController {
            present(filterVC, animated: true, completion: nil)
            self.filterViewController = filterVC
        }
    }
    
    //MARK: - EventFilterResponseProtocol delegate

    func okFilterButtonAction(filter:FilterProfile) {
        self.filter = filter
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

