//
//  EventFilterViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/5/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol EventFilterResponseProtocol: class {
    func okFilterButtonAction(filter:FilterValues)
    func cancelFilterButtonAction()
}


class EventFilterViewController: UIViewController {

    private var tableAdapter: FilterSettingsTableAdapter! = nil
    weak private var selectorDelegate:EventFilterResponseProtocol!
    weak private var resourcesModelController:RegionalResourcesModelController?
    let filterProfile = FilterInputTemplate()
    var filterVals:FilterValues! = nil

    @IBOutlet weak var filterTableViewOutlet: UITableView!
    
    func configuration(resources: RegionalResourcesModelController, selectorDelegate: EventFilterResponseProtocol, filter:FilterValues) {
        self.selectorDelegate = selectorDelegate
        self.resourcesModelController = resources
        self.filterVals = filter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterProfile.add(filter: ElementInteractor(using: .proximity(mileageBand: self.filterVals.proximityValue)))
        filterProfile.add(filter: ElementInteractor(using: .age(years: self.filterVals.ageValue)))
        filterProfile.add(filter: ElementInteractor(using: .developmentalAge(stage: self.filterVals.developmentalAgeValue)))
        filterProfile.add(filter: ElementInteractor(using: .mobilityLimitation(mobility: self.filterVals.mobilityValue)))
        filterProfile.add(filter: ElementInteractor(using: .primaryDiagnosis(primaryDx: self.filterVals.primaryDxValue)))
        filterProfile.add(filter: ElementInteractor(using: .secondaryDiagnosis(secondaryDx: self.filterVals.secondaryDxValue)))
        
        self.tableAdapter = FilterSettingsTableAdapter(table: self.filterTableViewOutlet, filterWhat: filterProfile)
    }

    deinit {
        print("deallocating EventFilterVC")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        let filterResults:FilterValues = filterProfile.createValues()
        //let label = filterResults.naturalLanguageText()
        //print(label)
        //print(filterResults.filterValues[0])
        self.selectorDelegate.okFilterButtonAction(filter: filterResults)
    }

}
