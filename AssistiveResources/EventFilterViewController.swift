//
//  EventFilterViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/5/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol EventFilterResponseProtocol: class {
    func okFilterButtonAction(filter:FilterProfile)
    func cancelFilterButtonAction()
}

class EventFilterViewController: UIViewController {

    private var tableAdapter: FilterSettingsTableAdapter! = nil
    weak private var selectorDelegate:EventFilterResponseProtocol!
    weak private var resourcesModelController:RegionalResourcesModelController?
    let filterTemplate = FilterInputTemplate()
    var filterProfile:FilterProfile! = nil

    @IBOutlet weak var filterTableViewOutlet: UITableView!
    
    func configuration(resources: RegionalResourcesModelController, selectorDelegate: EventFilterResponseProtocol, filter:FilterProfile) {
        self.selectorDelegate = selectorDelegate
        self.resourcesModelController = resources
        self.filterProfile = filter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTemplate.add(filter: ElementInteractor(using: .proximity(mileageBand: self.filterProfile.proximityValue)))
        filterTemplate.add(filter: ElementInteractor(using: .age(years: self.filterProfile.ageValue)))
        filterTemplate.add(filter: ElementInteractor(using: .developmentalAge(stage: self.filterProfile.developmentalAgeValue)))
        filterTemplate.add(filter: ElementInteractor(using: .mobilityLimitation(mobility: self.filterProfile.mobilityValue)))
        filterTemplate.add(filter: ElementInteractor(using: .primaryDiagnosis(primaryDx: self.filterProfile.primaryDxValue)))
        filterTemplate.add(filter: ElementInteractor(using: .secondaryDiagnosis(secondaryDx: self.filterProfile.secondaryDxValue)))
        
        self.tableAdapter = FilterSettingsTableAdapter(table: self.filterTableViewOutlet, filterWhat: filterTemplate)
    }

    deinit {
        print("deallocating EventFilterVC")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        let filterResults:FilterProfile = filterTemplate.createProfile()
        //let label = filterResults.naturalLanguageText()
        //print(label)
        //print(filterResults.filterValues[0])
        self.selectorDelegate.okFilterButtonAction(filter: filterResults)
    }
}
