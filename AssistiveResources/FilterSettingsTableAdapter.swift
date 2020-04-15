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
            return self.filterItems[indexPath.section].rowsVisible ? 45 : 0
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
            self.configHeaderCell(cell: cell, section: indexPath.section)
            return cell
            
        } else {
            // row for selecting an enumerated type (except for age)
            let isSelectedRow = filterItems[indexPath.section].selectedEnum == indexPath.row - 1
            let cell: FilterTableRowCell = tableView.dequeueReusableCell(withIdentifier: "FilterRowCellIdentifier") as! FilterTableRowCell
            cell.configure(text: self.filterItems[indexPath.section].enumText(rawValue: indexPath.row - 1), isChecked: isSelectedRow)
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
    }
    
    // MARK:- utilities
    
    private func configHeaderCell (cell:FilterTableHeaderCell, section:Int){
        var subtitle: String = ""

        switch filterItems[section].element {
        case is DiagnosisFilter:
            subtitle = filterItems[section].element.valueString
        default:
            let selectedCellIndex = self.filterItems[section].selectedEnum + 1
            subtitle = filterItems[section].enumText(rawValue: selectedCellIndex - 1)
        }
        cell.configure (mainText: self.filterItems[section].element.label,
                        headerEnabled: self.filterItems[section].sectionEnabled,
                        subText: subtitle,
                        subTextEnabled: filterItems[section].element.hasValue)
    }

    func selectMultiCell(at indexPath: IndexPath) {
        // hide current editable section if open and different header is tapped
        if (currentEditableSectionIndex != Constants.noSectionOpen && currentEditableSectionIndex != indexPath.section) {
            self.filterItems[currentEditableSectionIndex].rowsVisible = false
        }

        // reveal section if hidden (dont auto-hide)
        if filterItems[indexPath.section].rowsVisible == false {
            filterItems[indexPath.section].rowsVisible = true
            currentEditableSectionIndex = indexPath.section
        } else if indexPath.row == 0 {
            filterItems[indexPath.section].rowsVisible = false
            currentEditableSectionIndex = Constants.noSectionOpen
        }

        // update row cells
        if indexPath.row > 0 {
            filterItems[indexPath.section].element.update(rawValue: indexPath.row - 1)
            updateSection(indexPath.section)

            // update header with selection
            let headerCellIndex:IndexPath = IndexPath(row: 0, section: indexPath.section)
            let headerCell = tableView.cellForRow(at: headerCellIndex) as! FilterTableHeaderCell
            self.configHeaderCell(cell: headerCell, section: indexPath.section)
        }

        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }

    func selectListCell(at indexPath: IndexPath) {
        // hide CurrentEditableSection if open and different header is tapped
        if (currentEditableSectionIndex != Constants.noSectionOpen && currentEditableSectionIndex != indexPath.section) {
            self.filterItems[currentEditableSectionIndex].rowsVisible = false
        }

        // set section visible/hidden
        filterItems[indexPath.section].rowsVisible = !self.filterItems[indexPath.section].rowsVisible
        currentEditableSectionIndex = filterItems[indexPath.section].rowsVisible ? indexPath.section : Constants.noSectionOpen

        // update row cells
        if indexPath.row > 0 {
            let previousSelectionIndex = filterItems[indexPath.section].selectedEnum + 1

            // select row
            let isSelectedRow:Bool = filterItems[indexPath.section].selectedEnum + 1 == indexPath.row
            let newSelectionState:Bool = !isSelectedRow
            let newSelectionIndex = newSelectionState ? indexPath.row : Constants.noSelection
            filterItems[indexPath.section].selectEnum(rawValue: newSelectionIndex - 1)
            let cell:FilterTableRowCell = tableView.cellForRow(at: indexPath) as! FilterTableRowCell
            cell.checkmarkImageOutlet.isHidden = !newSelectionState

            // deselect prev checkmark
            if (previousSelectionIndex != Constants.noSelection && previousSelectionIndex != newSelectionIndex) {
                let previouslySelectedCellIndex:IndexPath = IndexPath(row: previousSelectionIndex, section: indexPath.section)
                if let previouslySelectedCell:FilterTableRowCell = tableView.cellForRow(at: previouslySelectedCellIndex) as? FilterTableRowCell {
                    // TODO - (number input)
                    previouslySelectedCell.checkmarkImageOutlet.isHidden = true
                }
            }

            // update header with selection
            let headerCellIndex:IndexPath = IndexPath(row: 0, section: indexPath.section)
            let headerCell:FilterTableHeaderCell = tableView.cellForRow(at: headerCellIndex) as! FilterTableHeaderCell
            self.configHeaderCell(cell: headerCell, section: indexPath.section)
        }

        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }

    func selectNumericCell(at indexPath: IndexPath) {
        // hide CurrentEditableSection if open and different header is tapped
        if indexPath.row == 0 {
            if (currentEditableSectionIndex != Constants.noSectionOpen && currentEditableSectionIndex != indexPath.section) {
                self.filterItems[currentEditableSectionIndex].rowsVisible = false
            }

            // set section visible/hidden
            filterItems[indexPath.section].rowsVisible = !self.filterItems[indexPath.section].rowsVisible
            currentEditableSectionIndex = filterItems[indexPath.section].rowsVisible ? indexPath.section : Constants.noSectionOpen

            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }

        // tap row cell
        if indexPath.row > 0 {
            // tbd
        }
    }

    func updateSection(_ section: Int) {
        let rowCount = filterItems[section].editableRowCount
        for index in 1 ..< rowCount {
            let isSelected = filterItems[section].element.isValueSelected(rawValue: index - 1)
            let cell: FilterTableRowCell = tableView.cellForRow(at: IndexPath(row: index, section: section)) as! FilterTableRowCell
            cell.checkmarkImageOutlet.isHidden = !isSelected
            cell.backgroundView?.setNeedsDisplay()
        }
        //tableView.reloadSections([section], with: UITableViewRowAnimation.automatic)
    }
}
