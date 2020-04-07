//
//  NavListViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


let updateNavigationNotificationKeyName = NSNotification.Name(rawValue: "key_notify_navigation_content_changed")


class NavListViewController: ProcessViewController {

    private var navigationData: NavigationContent!
    private var isVisible: Bool = false
    private var needContentRefresh: Bool = false
    
    @IBOutlet weak var navTable: UITableView!
    var tableAdaptor:MainNavigationTableAdaptor?
    
    func configuration() {
        self.navigationData = NavigationContent()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshContent), name: updateNavigationNotificationKeyName, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableAdaptor = MainNavigationTableAdaptor.init(table: self.navTable, navItems: navigationData, selector: { (destination:NavigationCategory) -> Void in
            self.requestAction(command: AssistiveCommand(type: .navigateTo(destination: destination)))
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isVisible = true
        if (self.needContentRefresh) {
            self.navTable.reloadData()
            self.needContentRefresh = false
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isVisible = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //freeMemory()
    }
    
    deinit {
        //print("deallocating NavListViewController")
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refreshContent() {
        self.navigationData.updateSubtitles()
        if (self.isVisible) {
            self.navTable.reloadData()
            self.needContentRefresh = false
        } else {
            self.needContentRefresh = true
        }
    }
    
}

//MARK: - helper functions

func requestMainNavigationRefresh() {
    NotificationCenter.default.post(name: updateNavigationNotificationKeyName, object: nil)
}


