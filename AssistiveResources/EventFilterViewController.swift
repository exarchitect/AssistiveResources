//
//  EventFilterViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/5/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol EventFilterResponseProtocol: class {
    func okFilterButtonAction(filter:FilterDictionary)
    func cancelFilterButtonAction()
}

class EventFilterViewController: UIViewController {

    private var tableAdapter: FilterSettingsTableAdapter! = nil
    weak private var selectorDelegate:EventFilterResponseProtocol!
    weak private var resourcesModelController:RegionalResourcesModelController?
    var filterList: [ElementInteractor] = []
    var filterProfile:FilterDictionary! = nil

    @IBOutlet weak var filterTableViewOutlet: UITableView!
    
    func configuration(resources: RegionalResourcesModelController?, selectorDelegate: EventFilterResponseProtocol, filter:FilterDictionary) {
        self.selectorDelegate = selectorDelegate
        self.resourcesModelController = resources
        self.filterProfile = filter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: pull this from ?
        filterList.append(ElementInteractor(using: ProximityFilter(range: .twentyFiveMiles)))
        filterList.append(ElementInteractor(using: AgeFilter(years: 21)))
        filterList.append(ElementInteractor(using: DevelopmentalAgeFilter(developmentalAge: .gradeschool)))
        filterList.append(ElementInteractor(using: MobilityFilter(mobilityLimit: .wheelchair)))
        filterList.append(ElementInteractor(using: DiagnosisFilter(diagnoses: [.autism])))

        self.tableAdapter = FilterSettingsTableAdapter(table: self.filterTableViewOutlet, filterWhat: filterList)
    }

    deinit {
        print("deallocating EventFilterVC")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        let filterResults = ElementInteractor.createFilterDictionary(from: filterList)
        self.selectorDelegate.okFilterButtonAction(filter: filterResults)
    }
}
