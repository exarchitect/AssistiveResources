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
    
    @IBOutlet weak var filterTableViewOutlet: UITableView!
    
    func configuration(resources: RegionalResourcesModelController, selectorDelegate: EventFilterResponseProtocol) {
        self.selectorDelegate = selectorDelegate
        self.resourcesModelController = resources
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profile = FilterProfile()
        profile.addSection(filter: ProximityFilterSection())
        profile.addSection(filter: AgeFilterSection())
        profile.addSection(filter: DevelopmentalAgeFilterSection())
        profile.addSection(filter: MobilityFilterSection())
        profile.addSection(filter: PrimaryDiagnosisFilterSection())
        profile.addSection(filter: SecondaryDiagnosisFilterSection())
        self.tableAdapter = FilterSettingsTableAdapter(table: self.filterTableViewOutlet, filterWhat: profile)
    }

    deinit {
        print("deallocating EventFilterVC")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        self.selectorDelegate.okFilterButtonAction()
    }

}
