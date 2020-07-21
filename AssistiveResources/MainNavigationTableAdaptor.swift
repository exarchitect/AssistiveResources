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

typealias DestinationSelector = (_ destination:NavigationCategory) -> Void



class MainNavigationTableAdaptor: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    weak private var navigationData: NavigationCategories!
    var selectorClosure: DestinationSelector!
    
    init(table: UITableView, navItems: NavigationCategories, selector: @escaping DestinationSelector) {
        super.init()
        
        self.tableView = table
        self.navigationData = navItems
        self.selectorClosure = selector
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.navigationData.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MainNavTableViewCell = tableView.dequeueReusableCell(withIdentifier: kHomeNavCellID) as! MainNavTableViewCell
        
        let _title = navigationData[indexPath.row].title
        let _subtitle = navigationData[indexPath.row].subtitle
        let _image = navigationData[indexPath.row].imageName
        cell .configureCell(title: _title, subTitle: _subtitle, imageName: _image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath as IndexPath, animated: true)
 
        self.selectorClosure?(navigationData[indexPath.row].destination)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    // debug
    deinit {
        let _ = 0
        print("deallocating MainNavigationTableAdaptor")
    }
    
}


