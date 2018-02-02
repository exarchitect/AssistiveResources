//
//  FilterSettingsTableAdapter.swift
//  AssistiveResources
//
//  Created by WCJ on 1/30/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import UIKit


//typealias FilterSelector = (_ destination:NavigationCategory) -> Void


class FilterSettingsTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    weak private var filter: FilterProfile!

    init(table: UITableView, filterWhat: FilterProfile) {
        super.init()
        
        self.tableView = table
        self.filter = filterWhat
        
        // attach table
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.white
    }
    
    
    //MARK: tableView delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kHomeNavCellHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filter.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return "temp"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filter[section].editableRowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            // section header
            if (filter[indexPath.section].filterType == .NoCharacteristic) {
                // Major Heading
                let cell:MainNavTableViewCell = tableView.dequeueReusableCell(withIdentifier: kHomeNavCellID) as! MainNavTableViewCell
                
                return cell
            } else {
                // section heading
                let cell:MainNavTableViewCell = tableView.dequeueReusableCell(withIdentifier: kHomeNavCellID) as! MainNavTableViewCell
                
//                let _cellTitle = filter[indexPath.section].rowTitle(atIndex: indexPath.row+1)
                
//                let _title = navigationData[indexPath.row].title
//                let _subtitle = navigationData[indexPath.row].subtitle
//                let _image = navigationData[indexPath.row].imageName
//                cell .configureCell(title: _title, subTitle: _subtitle, imageName: _image)
                
                return cell
            }
            
        } else {
            // row cell
            if (filter[indexPath.section].filterType == .Age) {
                // age input
                let cell:MainNavTableViewCell = tableView.dequeueReusableCell(withIdentifier: kHomeNavCellID) as! MainNavTableViewCell
                
                return cell
            } else {
                // enum input
                let cell:MainNavTableViewCell = tableView.dequeueReusableCell(withIdentifier: kHomeNavCellID) as! MainNavTableViewCell

                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath as IndexPath, animated: true)
        
//        self.selectorClosure?(navigationData[indexPath.row].destination)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // debug
    
    deinit {
        print("deallocating FilterSettingsTableAdapter")
    }
}


// MARK:- Filter - generic classes

enum FilterCharacteristic : Int {
    case NoCharacteristic, Age, Proximity, DevelopmentalAge, MobilityLimitation, PrimaryDiagnosis, SecondaryDiagnosis
}

class FilterSectionDescriptor: NSObject {
    var headerTitle: String = ""
    var editableRowCount = 0
    var rowsVisible: Bool = false
    var filterType: FilterCharacteristic = .NoCharacteristic
    
    var isSelected: Bool = false
    var valueText: String = ""

    func rowTitle(atIndex: Int) -> String {
        return self.headerTitle
    }
}

class FilterProfile: NSObject {
    
    private var sectionList:[FilterSectionDescriptor] = []
    var count: Int {
        return sectionList.count
    }
    subscript(pos: Int) -> FilterSectionDescriptor {
        return sectionList[pos]
    }
    func addSection(filter: FilterSectionDescriptor) {
        self.sectionList.append(filter)
    }
}


// MARK:- Filter - specific

class HeaderFilterSection: FilterSectionDescriptor {
    
    init (headerTitle: String) {
        super.init()
        self.headerTitle = headerTitle
    }
}

class ProximityFilterSection: FilterSectionDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Proximity"
        self.editableRowCount = 1
        self.rowsVisible = true
        self.filterType = .Proximity
    }
}

class AgeFilterSection: FilterSectionDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Age"
        self.editableRowCount = 1
        self.rowsVisible = true
        self.filterType = .Age
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return "???"
    }
}

class DevelopmentalAgeFilterSection: FilterSectionDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Developmental Age"
        self.editableRowCount = DevelopmentalAge.caseCount
        self.rowsVisible = true
        self.filterType = .DevelopmentalAge
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return DevelopmentalAge.titleAtIndex[atIndex]
    }
}

class MobilityFilterSection: FilterSectionDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Mobility Limitation"
        self.editableRowCount = MobilityLimitation.caseCount
        self.rowsVisible = true
        self.filterType = .MobilityLimitation
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return MobilityLimitation.titleAtIndex[atIndex]
    }
}

class PrimaryDiagnosisFilterSection: FilterSectionDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Primary Diagnosis"
        self.editableRowCount = Diagnosis.caseCount
        self.rowsVisible = true
        self.filterType = .PrimaryDiagnosis
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return Diagnosis.titleAtIndex[atIndex]
    }
}

class SecondaryDiagnosisFilterSection: FilterSectionDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Secondary Diagnosis"
        self.editableRowCount = Diagnosis.caseCount
        self.rowsVisible = true
        self.filterType = .SecondaryDiagnosis
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return Diagnosis.titleAtIndex[atIndex]
    }
}



