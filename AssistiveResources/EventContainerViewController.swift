//
//  EventContainerViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol EventListContainerNotificationProtocol: class {
    func notifyRowDetailSelected(rowIndex: Int)
    func notifyFilterSelected()
}


class EventContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RepositoryAccessorProtocol {

    @IBOutlet weak var containerTableView: UITableView!
    @IBOutlet weak var filterValueDescriptionLabelOutlet: UILabel?
    
    weak private var notificationDelegate:EventListContainerNotificationProtocol?
    private var expandedRowIndex = -1
    private var showLoadingIndicator: Bool = false
    private var eventAccessor: EventRepositoryAccessor!
    private var filter: FilterDictionary?


    func configuration(rsrcModelController: RegionalResourcesModelController, delegate: EventListContainerNotificationProtocol) {
    
        notificationDelegate = delegate

        self.eventAccessor = rsrcModelController.createEventAccessor(delegate: self)
        guard self.eventAccessor != nil else {
            return
        }
    }
    
    func setFilter(fltr: FilterDictionary) {
        filter = fltr
        filterValueDescriptionLabelOutlet?.text = ElementInteractor.naturalLanguageText(filters: fltr)
    }

    //MARK: - overrides

    deinit {
        let _ = 0
        //print("deallocating EventContainerVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerTableView.delegate = self
        containerTableView.dataSource = self
        
        containerTableView.separatorInset = UIEdgeInsets.zero
        containerTableView.separatorColor = UIColor.blue
        containerTableView.backgroundColor = UIColor.white
        
        containerTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))   // this gets rid of separator lines for empty cells
        
        eventAccessor.requestData(filteredBy: FilterDictionary())
        if (self.eventAccessor.state == .notLoaded) {
            self.showLoadingIndicator = true
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now())) {
                startActivityIndicator(title: nil, message: "loading...")
            }
        }
        guard let filterDictionary = filter else {
            return
        }
        filterValueDescriptionLabelOutlet?.text = ElementInteractor.naturalLanguageText(filters: filterDictionary)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        //freeMemory()
    }
    
    
    //MARK: - RepositoryAccessorProtocol
    
    func notifyRepositoryWasUpdated() {
        if (self.showLoadingIndicator) {
            self.showLoadingIndicator = false
            stopActivityIndicator()
        }
        
        self.containerTableView.reloadData()
    }

    //MARK: - utils
    
    private func expandCollapseRow(row: Int)
    {
        var indexPathToExpand : IndexPath
        var indexPathToCollapse : IndexPath
        var pathArray : NSArray
        
        if (expandedRowIndex >= 0) {    // have an expanded row
            if (row == expandedRowIndex) {
                indexPathToCollapse = IndexPath(row: row, section: 0)
                pathArray = NSArray(objects: indexPathToCollapse)
                expandedRowIndex = -1
            } else {
                indexPathToExpand = IndexPath(row: row, section: 0)
                indexPathToCollapse = IndexPath(row: expandedRowIndex, section: 0)
                pathArray = NSArray(objects: indexPathToExpand, indexPathToCollapse)
                expandedRowIndex = row
            }
        } else {
            indexPathToExpand = IndexPath(row: row, section: 0)
            pathArray = NSArray(objects: indexPathToExpand)
            expandedRowIndex = row
        }
        containerTableView.reloadRows(at: pathArray as! [IndexPath], with: UITableViewRowAnimation.automatic)
    }
    
    //MARK: - tableView delegates
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (expandedRowIndex == indexPath.row) ? 286.0 : 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventAccessor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kEventListCellID = "EventListCellIdentifier"
        
        let cell:EventListTableViewCell = tableView.dequeueReusableCell(withIdentifier: kEventListCellID) as! EventListTableViewCell
        
        let event:StoredEvent = self.eventAccessor[indexPath.row]
        cell.configureCell(event: event, expand: expandedRowIndex == indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        expandCollapseRow(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - @IBAction
    
    @IBAction func showRowDetailButtonAction(_ sender: UIButton) {
        let row = getRowFrom(sender, self.containerTableView)
        if row > -1 {
            notificationDelegate?.notifyRowDetailSelected(rowIndex: row)
        }
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        if (!self.showLoadingIndicator) {
            notificationDelegate?.notifyFilterSelected()
        }
    }
 
    @IBAction func filterTextButtonAction(_ sender: Any) {
        if (!self.showLoadingIndicator) {
            notificationDelegate?.notifyFilterSelected()
        }
    }
    
}


// MARK: - funcs

func getRowFrom(_ cellItem: UIView, _ fromTable: UITableView) -> Int {
    var parentCell: UIView! = cellItem as UIView
    var returnRow = -1
    
    repeat {
        parentCell = parentCell.superview!
    } while !(parentCell is UITableViewCell)
    let cell = parentCell as! UITableViewCell
    let indxPath = fromTable.indexPath(for: cell)
    
    if let row = indxPath?.row {
        returnRow = row
    }
    return returnRow
}

