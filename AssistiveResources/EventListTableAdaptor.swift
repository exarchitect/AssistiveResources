//
//  EventListTableAdaptor.swift
//  SwiftNeed
//
//  Created by Bill Johnson on 5/16/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol EventListTableAdaptorNotificationProtocol {
    func notifyRowSelected(rowIndex: Int)
    func notifyRowDeleted(rowIndex: Int)
}


class EventListTableAdaptor: NSObject, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var resources: ResourcesModelController!
    var notificationDelegate:EventListTableAdaptorNotificationProtocol?
    var expandedRowIndex = -1
    
    init(table: UITableView, rsrcModelController: ResourcesModelController, delegate: EventListTableAdaptorNotificationProtocol) {
        super.init()
        
        tableView = table
        resources = rsrcModelController
        notificationDelegate = delegate
        
        // attach table
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.blue
        tableView.backgroundColor = UIColor.white

        //tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))   // this gets rid of separator lines for empty cells
    }
    
    
    //MARK: utils
    
    func expandCollapseRow(row: Int)
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
        tableView.reloadRows(at: pathArray as! [IndexPath], with: UITableViewRowAnimation.automatic)
    }
    
    //MARK: tableView delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (expandedRowIndex == indexPath.row) ? 286.0 : 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources.eventCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kEventListCellID = "EventListCellIdentifier"
        
        let cell:EventListTableViewCell = tableView.dequeueReusableCell(withIdentifier: kEventListCellID) as! EventListTableViewCell

        let event:PublicEvent = resources[indexPath.row]
        cell.configureCell(event: event, expand: expandedRowIndex == indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        expandCollapseRow(row: indexPath.row)
        notificationDelegate?.notifyRowSelected(rowIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    //        if editingStyle == UITableViewCellEditingStyle .Delete {
    //            notificationDelegate?.notifyRowDeleted(indexPath.row)
    //        }
    //    }
    
}
