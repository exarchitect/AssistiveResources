//
//  FilterSettingsTableAdapter.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/30/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import UIKit

class FilterSettingsTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    private var filterItems: [ElementInteractor]!
    private var currentEditableSectionIndex: Int = Constants.noSectionOpen

    init(table: UITableView, filterWhat: [ElementInteractor]) {
        super.init()
        
        self.tableView = table
        self.filterItems = filterWhat
        
        // attach table
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.white
        tableView.backgroundColor = UIColor.white
        
    }
    
    deinit {
        print("deallocating FilterSettingsTableAdapter")
    }

    //MARK: tableView delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 68       // header
        } else {
            return self.filterItems[indexPath.section].editInProgress ? 45 : 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filterItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterItems[section].editableRowCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            // section heading is first row cell so we can detect hits
            let cell:FilterTableHeaderCell = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableHeaderCell
            configHeaderCell(cell: cell, section: indexPath.section)
            return cell
            
        } else {
            // row for selecting an enumerated type (except for age)
            let isSelectedRow = filterItems[indexPath.section].element.isValueSelected(rawValue: indexPath.row.rowToEnum())
            let cell: FilterTableRowCell = tableView.dequeueReusableCell(withIdentifier: "FilterRowCellIdentifier") as! FilterTableRowCell
            cell.configure(text: self.filterItems[indexPath.section].summaryText(rawValue: indexPath.row.rowToEnum()), isChecked: isSelectedRow)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)

        switch filterItems[indexPath.section].editType {
        case .singleselect:
            selectListCell(at: indexPath)
        case .multiselect:
            selectMultiCell(at: indexPath)
        case .numeric:
            selectNumericCell(at: indexPath)
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    // MARK:- utilities
    
    private func configHeaderCell (cell:FilterTableHeaderCell, section:Int){
        let subtitle = filterItems[section].element.valueString
        cell.configure (mainText: self.filterItems[section].element.label,
                        headerEnabled: true,
                        subText: subtitle,
                        subTextEnabled: filterItems[section].element.hasValue)
    }

    func selectMultiCell(at indexPath: IndexPath) {
        showHideSections(at: indexPath, multiSelect: true)

        // update rows
        if indexPath.row > 0 {
            filterItems[indexPath.section].element.toggleSelection(rawValue: indexPath.row.rowToEnum())
            updateSection(indexPath.section)

            // update header with selection
            let headerCellIndex:IndexPath = IndexPath(row: 0, section: indexPath.section)
            let headerCell = tableView.cellForRow(at: headerCellIndex) as! FilterTableHeaderCell
            self.configHeaderCell(cell: headerCell, section: indexPath.section)
        }
    }

    func selectListCell(at indexPath: IndexPath) {
        showHideSections(at: indexPath)

        // update rows
        if indexPath.row > 0 {
            filterItems[indexPath.section].element.toggleSelection(rawValue: indexPath.row.rowToEnum())
            updateSection(indexPath.section)

            // update header with selection
            let headerCellIndex:IndexPath = IndexPath(row: 0, section: indexPath.section)
            let headerCell:FilterTableHeaderCell = tableView.cellForRow(at: headerCellIndex) as! FilterTableHeaderCell
            self.configHeaderCell(cell: headerCell, section: indexPath.section)
        }
    }

    func selectNumericCell(at indexPath: IndexPath) {
        if indexPath.row == 0 {
            showHideSections(at: indexPath)
        }

        // tap row cell
        if indexPath.row > 0 {
            // tbd
        }
    }

    func showHideSections(at indexPath: IndexPath, multiSelect: Bool = false) {
        // hide previous editable section if open and different section is becoming editable
        if (currentEditableSectionIndex != Constants.noSectionOpen && currentEditableSectionIndex != indexPath.section) {
            filterItems[currentEditableSectionIndex].editInProgress = false
        }

        if multiSelect {
            // reveal section if hidden (dont auto-hide)
            if filterItems[indexPath.section].editInProgress == false {
                filterItems[indexPath.section].editInProgress = true
                currentEditableSectionIndex = indexPath.section
            } else if indexPath.row == 0 {
                filterItems[indexPath.section].editInProgress = false
                currentEditableSectionIndex = Constants.noSectionOpen
            }
        } else {
            // set section visible/hidden
            filterItems[indexPath.section].editInProgress = !self.filterItems[indexPath.section].editInProgress
            currentEditableSectionIndex = filterItems[indexPath.section].editInProgress ? indexPath.section : Constants.noSectionOpen
        }
    }

    func updateSection(_ section: Int) {
        let rowCount = filterItems[section].editableRowCount
        for rowIndex in 1 ... rowCount {
            let isSelected = filterItems[section].element.isValueSelected(rawValue: rowIndex.rowToEnum())
            let cell: FilterTableRowCell = tableView.cellForRow(at: IndexPath(row: rowIndex, section: section)) as! FilterTableRowCell
            cell.checkmarkImageOutlet.isHidden = !isSelected
            cell.backgroundView?.setNeedsDisplay()
        }
    }
}

extension Int {
    func enumToRow() -> Int {
        self + 1
    }

    func rowToEnum() -> Int {
        self - 1
    }
}
