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
        filterList.append(ElementInteractor(using: ProximityClass(range: .twentyFiveMiles)))
        filterList.append(ElementInteractor(using: AgeClass(years: 21)))
        filterList.append(ElementInteractor(using: DevelopmentalAgeClass(developmentalAge: .notSpecified)))
        filterList.append(ElementInteractor(using: MobilityClass(mobilityLimit: .notSpecified)))
        filterList.append(ElementInteractor(using: DiagnosisClass(diagnosis: .notSpecified)))
        //filterList.append(ElementInteractor(using: FilteringElement.additionalDiagnoses(secondaryDx: .notSpecified)))
        
//        filterList.append(ElementInteractor(using: .proximity(mileageBand: self.filterProfile.proximityValue)))
//        filterList.append(ElementInteractor(using: .age(years: self.filterProfile.ageValue)))
//        filterList.append(ElementInteractor(using: .developmentalAge(stage: self.filterProfile.developmentalAgeValue)))
//        filterList.append(ElementInteractor(using: .mobilityLimitation(mobility: self.filterProfile.mobilityValue)))
//        filterList.append(ElementInteractor(using: .primaryDiagnosis(primaryDx: self.filterProfile.primaryDxValue)))
//        filterList.append(ElementInteractor(using: .additionalDiagnoses(secondaryDx: self.filterProfile.secondaryDxValue)))

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
        //let label = filterResults.naturalLanguageText()
        //print(label)
        //print(filterResults.filterValues[0])
        self.selectorDelegate.okFilterButtonAction(filter: filterResults)
    }
}
