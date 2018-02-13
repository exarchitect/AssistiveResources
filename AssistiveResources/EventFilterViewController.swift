//
//  EventFilterViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/5/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol EventFilterResponseProtocol: class {
    func okFilterButtonAction ()
    func cancelFilterButtonAction ()
}


class EventFilterViewController: UIViewController {

    private var tableAdapter: FilterSettingsTableAdapter! = nil
    weak private var selectorDelegate:EventFilterResponseProtocol!
    weak private var resourcesModelController:RegionalResourcesModelController?
    let filterProfile = FilterInputTemplate()

    @IBOutlet weak var filterTableViewOutlet: UITableView!
    
    func configuration(resources: RegionalResourcesModelController, selectorDelegate: EventFilterResponseProtocol) {
        self.selectorDelegate = selectorDelegate
        self.resourcesModelController = resources
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filterValues = FilterValues()
        filterValues.developmentalAgeValue = .PreschoolDevelopmentalAge
        filterValues.proximityValue = .TwentyFiveMiles
        filterValues.ageValue = 21

//        let filterProfile = FilterInputTemplate()
        filterProfile.add(filter: FilterDescriptor(category: FilterType.Proximity(mileageBand: filterValues.proximityValue)))
        filterProfile.add(filter: FilterDescriptor(category: FilterType.Age(years: filterValues.ageValue)))
        filterProfile.add(filter: FilterDescriptor(category: FilterType.DevelopmentalAge(stage: filterValues.developmentalAgeValue)))
        filterProfile.add(filter: FilterDescriptor(category: FilterType.MobilityLimitation(mobility: filterValues.mobilityValue)))
        filterProfile.add(filter: FilterDescriptor(category: FilterType.PrimaryDiagnosis(primaryDx: filterValues.primaryDxValue)))
        filterProfile.add(filter: FilterDescriptor(category: FilterType.SecondaryDiagnosis(secondaryDx: filterValues.secondaryDxValue)))
        
        //filterProfile.

        // existing
//        let profile = FilterProfile()
//        profile.addSection(filter: ProximityFilterSection())
//        profile.addSection(filter: AgeFilterSection())
//        profile.addSection(filter: DevelopmentalAgeFilterSection())
//        profile.addSection(filter: MobilityFilterSection())
//        profile.addSection(filter: PrimaryDiagnosisFilterSection())
//        profile.addSection(filter: SecondaryDiagnosisFilterSection())
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
        let label = filterResults.descriptiveText()
        print(label)
        //print(filterResults.filterValues[0])
        self.selectorDelegate.okFilterButtonAction()
    }

}
