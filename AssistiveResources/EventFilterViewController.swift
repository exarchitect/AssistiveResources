//
//  EventFilterViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/5/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol EventFilterResponse: class {
    func okFilterButtonAction(filter: FilterDictionary)
    func cancelFilterButtonAction()
}

class EventFilterViewController: UIViewController {

    weak private var selectorDelegate:EventFilterResponse!
    weak private var resourcesModelController:RegionalResourcesModelController?
    var filter:FilterDictionary?

    var tableView: UITableView?
    var filterItems: [ElementInteractor]!
    var pickerData = MonthYearPickerData()

    @IBOutlet weak var filterTableViewOutlet: UITableView!
    
    func configuration(resources: RegionalResourcesModelController?, selectorDelegate: EventFilterResponse, filter: FilterDictionary) {
        self.selectorDelegate = selectorDelegate
        self.resourcesModelController = resources
        self.filter = filter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let filterList = filter else {
            return
        }
        self.tableView = self.filterTableViewOutlet
        initTable(filterBy: filterList)
    }

    deinit {
        print("deallocating EventFilterVC")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        guard let filterList = filterItems else {
            return
        }
        let filterDictionary = ElementInteractor.createFilterDictionary(from: filterList)
        self.selectorDelegate.okFilterButtonAction(filter: filterDictionary)
    }
}
