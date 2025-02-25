//
//  MainNavigationTableAdaptor.swift
//  SwiftNeed
//
//  Created by Bill Johnson on 5/12/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


let kHomeNavCellID = "HomeNavigationCellIdentifier"
let kHomeNavCellHeight: CGFloat = 90.0

typealias DestinationSelector = (_ destination:Destination) -> Void

//protocol MainNavTableAdaptorNotificationProtocol
//{
//    func notifyRowSelected(dest: Destination)
//    func notifyRowDeleted(rowIndex: Int)
//}


class MainNavigationTableAdaptor: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    private var navigationData: NavigationContent!
    //var repository: EventOfInterestRepository!
    //var navigationArray:[DestinationDescriptor] = []
    var selectorCallback: DestinationSelector!
    
    init(table: UITableView, navItems: NavigationContent, selector: @escaping DestinationSelector) {
        super.init()
        
        self.tableView = table
        self.navigationData = navItems
        //repository = repo
        self.selectorCallback = selector
        
//        setupNavigation()
        
        // attach table
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.white
    }
    
    //MARK: utils
    
//    func setupNavigation() {
//        
//        navigationArray.append(DestinationDescriptor(dest: Destination.Organizations))
//        navigationArray.append(DestinationDescriptor(dest: Destination.Events))
//        navigationArray.append(DestinationDescriptor(dest: Destination.Facilities))
//        navigationArray.append(DestinationDescriptor(dest: Destination.Travel))
//        navigationArray.append(DestinationDescriptor(dest: Destination.News))
//        navigationArray.append(DestinationDescriptor(dest: Destination.Inbox, subtitle: "You have 3 unread messages"))
//        navigationArray.append(DestinationDescriptor(dest: Destination.Profile))
//    }
    
    
    //MARK: tableView delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kHomeNavCellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (self.navigationArray.count)
        return (self.navigationData.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MainNavTableViewCell = tableView.dequeueReusableCell(withIdentifier: kHomeNavCellID) as! MainNavTableViewCell
        
//        let _title = navigationArray[indexPath.row].title
//        let _subtitle = navigationArray[indexPath.row].subTitle
//        let _image = navigationArray[indexPath.row].imageName
        let _title = navigationData[indexPath.row].title
        let _subtitle = navigationData[indexPath.row].subtitle
        let _image = navigationData[indexPath.row].imageName
        cell .configureCell(title: _title, subTitle: _subtitle, imageName: _image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath as IndexPath, animated: true)
 
//        self.selectorCallback?(navigationArray[indexPath.row].destination)
        self.selectorCallback?(navigationData[indexPath.row].destination)
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


