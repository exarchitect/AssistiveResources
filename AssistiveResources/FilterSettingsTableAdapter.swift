//
//  FilterSettingsTableAdapter.swift
//  AssistiveResources
//
//  Created by WCJ on 1/30/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import UIKit

class FilterSettingsTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    private var filterTemplate: FilterInputTemplate!
    private var indexOfCurrentEditableSection: Int = Constants.noSectionOpen

    init(table: UITableView, filterWhat: FilterInputTemplate) {
        super.init()
        
        self.tableView = table
        self.filterTemplate = filterWhat
        
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
            return self.filterTemplate[indexPath.section].rowsVisible ? 45 : 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filterTemplate.elementCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterTemplate[section].editableRowCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            // section heading is first row cell so we can detect hits
            let cell:FilterTableHeaderCell = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableHeaderCell
            self.configHeaderCell(cell: cell, section: indexPath.section)
            return cell
            
        } else {
            // row for selecting an enumerated type (except for age)
            let isSelectedRow:Bool = filterTemplate[indexPath.section].selectionIndex == indexPath.row
            let cell:FilterTableRowCell = tableView.dequeueReusableCell(withIdentifier: "FilterRowCellIdentifier") as! FilterTableRowCell
            cell.configure(text: self.filterTemplate[indexPath.section].element.itemText(at: indexPath.row), isChecked: isSelectedRow)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)

        switch filterTemplate[indexPath.section].editType {
        case .list:
            selectListCell(at: indexPath)
        case .numeric:
            selectNumericCell(at: indexPath)
        }
    }
    
    // MARK:- utilities
    
    private func configHeaderCell (cell:FilterTableHeaderCell, section:Int){
        let selectedCellIndex = self.filterTemplate[section].selectionIndex
        cell.configure (mainText: self.filterTemplate[section].element.title,
                        headerEnabled: self.filterTemplate[section].sectionEnabled,
                        subText: filterTemplate[section].element.itemText(at: selectedCellIndex),
                        subTextEnabled: filterTemplate[section].element.hasValue)
    }

    func selectListCell(at indexPath: IndexPath) {
        // hide this section when open, either if the header is tapped, or one of its rows is tapped
        if (indexOfCurrentEditableSection != Constants.noSectionOpen && indexOfCurrentEditableSection != indexPath.section) {
            self.filterTemplate[indexOfCurrentEditableSection].rowsVisible = false
        }

        // set section visible/hidden
        filterTemplate[indexPath.section].rowsVisible = !self.filterTemplate[indexPath.section].rowsVisible
        indexOfCurrentEditableSection = filterTemplate[indexPath.section].rowsVisible ? indexPath.section : Constants.noSectionOpen

        // update row cells
        if indexPath.row > 0 {
            let previousSelectionIndex = filterTemplate[indexPath.section].selectionIndex

            // select row
            let isSelectedRow:Bool = filterTemplate[indexPath.section].selectionIndex == indexPath.row
            let newSelectionState:Bool = !isSelectedRow
            let newSelectionIndex = newSelectionState ? indexPath.row : Constants.noSelection
            filterTemplate[indexPath.section].selectItem(at: newSelectionIndex)
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
        // hide this section when open if the header is tapped
        if indexPath.row == 0 {
            if (indexOfCurrentEditableSection != Constants.noSectionOpen && indexOfCurrentEditableSection != indexPath.section) {
                self.filterTemplate[indexOfCurrentEditableSection].rowsVisible = false
            }

            // set section visible/hidden
            filterTemplate[indexPath.section].rowsVisible = !self.filterTemplate[indexPath.section].rowsVisible
            indexOfCurrentEditableSection = filterTemplate[indexPath.section].rowsVisible ? indexPath.section : Constants.noSectionOpen

            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }

        // tap row cell
        if indexPath.row > 0 {
            // tbd
        }
    }
}
