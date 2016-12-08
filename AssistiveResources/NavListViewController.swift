//
//  NavListViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol NavigationSelectorProtocol {
    func selectNavigationItem (selection: Destination)
}


class NavListViewController: UIViewController {

    private var selectorDelegate: NavigationSelectorProtocol?
    private var navigationData: NavigationContent!
    private var isCurrentlyVisible: Bool = false
    private var needContentRefresh: Bool = false
    
    @IBOutlet weak var navTable: UITableView!
    var tableAdaptor:MainNavigationTableAdaptor?
    
    func dependencies(navItems: NavigationContent, selectorDelegate: NavigationSelectorProtocol) {
        self.selectorDelegate = selectorDelegate
        self.navigationData = navItems

        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshContent), name: updateNotificationKeyName, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        precondition(self.selectorDelegate != nil)
        precondition(self.navigationData != nil)

        self.tableAdaptor = MainNavigationTableAdaptor.init(table: self.navTable, navItems: navigationData, selector: { (destination:Destination) -> Void in
            
            self.selectorDelegate?.selectNavigationItem(selection: destination)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isCurrentlyVisible = true
        if (self.needContentRefresh) {
            self.navTable.reloadData()
            self.needContentRefresh = false
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isCurrentlyVisible = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        freeMemory()
    }
    
    func refreshContent() {
        self.navigationData.updateSubtitles()
        if (self.isCurrentlyVisible) {
            self.navTable.reloadData()
            self.needContentRefresh = false
        } else {
            self.needContentRefresh = true
        }
    }
    
}

//MARK: helper functions

func requestMainNavigationRefresh() {
    NotificationCenter.default.post(name: updateNotificationKeyName, object: nil)
}


