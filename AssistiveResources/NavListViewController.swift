//
//  NavListViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


let updateNavigationNotificationKeyName = NSNotification.Name(rawValue: "key_notify_navigation_content_changed")


//protocol NavigationSelectorProtocol {
//    func selectNavigationItem (selection: NavigationCategory)
//}


class NavListViewController: UIViewController {

    private var selectionDelegate: ProcessControllerResponseProtocol?
    private var navigationData: NavigationContent!
    private var isCurrentlyVisible: Bool = false
    private var needContentRefresh: Bool = false
    
    @IBOutlet weak var navTable: UITableView!
    var tableAdaptor:MainNavigationTableAdaptor?
    
    func configuration(navItems: NavigationContent, navDelegate: ProcessControllerResponseProtocol) {
        self.selectionDelegate = navDelegate
        self.navigationData = navItems

        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshContent), name: updateNavigationNotificationKeyName, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        precondition(self.selectionDelegate != nil)
        precondition(self.navigationData != nil)

        self.tableAdaptor = MainNavigationTableAdaptor.init(table: self.navTable, navItems: navigationData, selector: { (destination:NavigationCategory) -> Void in
            
//            self.selectionDelegate?.selectNavigationItem(selection: destination)
            self.selectionDelegate?.requestAction(command: AssistiveCommand(type: .navigationItemSelected(selection: destination)))
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
        
        //freeMemory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
    
    //MARK: - debug
    deinit {
        print("deallocating NavListViewController")
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK: - helper functions

func requestMainNavigationRefresh() {
    NotificationCenter.default.post(name: updateNavigationNotificationKeyName, object: nil)
}


