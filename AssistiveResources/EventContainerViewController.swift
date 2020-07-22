//
//  EventContainerViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol EventSelectionNotification: class {
    func showEventDetail(for descriptor: EventDescriptor)
    func modifyEventFilter()
}


class EventContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CacheUpdateNotification {

    @IBOutlet weak var containerTableView: UITableView!
    @IBOutlet weak var filterValueDescriptionLabelOutlet: UILabel?

    weak private var notificationDelegate:EventSelectionNotification?
    private var expandedRowIndex = -1
    private var eventAccessor: EventCacheAccessor!
    private var filter: FilterDictionary?
    private var activityIndicator = ActivityIndicatorAlert()

    func configuration(rsrcModelController: RegionalResourcesModelController, delegate: EventSelectionNotification) {

        notificationDelegate = delegate
        guard let eventAccessor = rsrcModelController.createEventAccessor(delegate: self) else {
            return
        }
        self.eventAccessor = eventAccessor
    }

    func setFilter(fltr: FilterDictionary) {
        filter = fltr
        filterValueDescriptionLabelOutlet?.text = ElementInteractor.naturalLanguageText(filters: fltr)
    }

    //MARK: - overrides

    deinit {
        print("deallocating EventContainerVC")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerTableView.delegate = self
        containerTableView.dataSource = self
        
        containerTableView.separatorInset = UIEdgeInsets.zero
        containerTableView.separatorColor = UIColor.blue
        containerTableView.backgroundColor = UIColor.white
        
        containerTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))   // this gets rid of separator lines for empty cells
        
        eventAccessor.loadCache(using: FilterDictionary())
        if eventAccessor.cacheState == .notLoaded {
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now())) {
                self.activityIndicator.start(title: nil, message: "loading...\n")
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
    
    
    //MARK: - CacheUpdateProtocol
    
    func cacheUpdated() {
        activityIndicator.stop()

        containerTableView.reloadData()
    }

    //MARK: - utils

    private func expandCollapseRow(row: Int)
    {
        var indexPathToExpand : IndexPath
        var indexPathToCollapse : IndexPath
        var pathArray : NSArray

        if expandedRowIndex >= 0 {    // there is an existing expanded row
            if row == expandedRowIndex {    // selected row is already expanded
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
        
        let cell: EventListTableViewCell = tableView.dequeueReusableCell(withIdentifier: kEventListCellID) as! EventListTableViewCell
        
        guard let event = eventAccessor[indexPath.row] else {
            return cell
        }
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
        guard row > -1, let descriptor = eventAccessor[row]?.descriptor else {
            return
        }
        notificationDelegate?.showEventDetail(for: descriptor)
    }

    @IBAction func filterButtonAction(_ sender: Any) {
        if eventAccessor.cacheState == .loaded {
            notificationDelegate?.modifyEventFilter()
        }
    }

    @IBAction func filterTextButtonAction(_ sender: Any) {
        if eventAccessor.cacheState == .loaded {
            notificationDelegate?.modifyEventFilter()
        }
    }
}


// MARK: - funcs

func getRowFrom(_ cellItem: UIView, _ table: UITableView) -> Int {
    var parentCell: UIView! = cellItem as UIView
    var returnRow = -1

    repeat {
        parentCell = parentCell.superview!
    } while !(parentCell is UITableViewCell)
    let cell = parentCell as! UITableViewCell
    let indxPath = table.indexPath(for: cell)
    
    if let row = indxPath?.row {
        returnRow = row
    }
    return returnRow
}

