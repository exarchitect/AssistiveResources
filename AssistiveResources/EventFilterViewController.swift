//
//  EventFilterViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/5/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol EventFilterResponseProtocol: class {
    func okFilterButtonAction(filter: FilterDictionary)
    func cancelFilterButtonAction()
}

class EventFilterViewController: UIViewController {

    private var tableAdapter: FilterSettingsTableAdapter?
    weak private var selectorDelegate:EventFilterResponseProtocol!
    weak private var resourcesModelController:RegionalResourcesModelController?
    var filter:FilterDictionary! = nil

    @IBOutlet weak var filterTableViewOutlet: UITableView!
    
    func configuration(resources: RegionalResourcesModelController?, selectorDelegate: EventFilterResponseProtocol, filter: FilterDictionary) {
        self.selectorDelegate = selectorDelegate
        self.resourcesModelController = resources
        self.filter = filter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableAdapter = FilterSettingsTableAdapter(table: self.filterTableViewOutlet, parentViewController: self, filterBy: filter)
    }

    deinit {
        print("deallocating EventFilterVC")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        guard let filterList = tableAdapter?.filterItems else {
            return
        }
        let filterDictionary = ElementInteractor.createFilterDictionary(from: filterList)
        self.selectorDelegate.okFilterButtonAction(filter: filterDictionary)
    }
}
