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

    private var navigationItems = NavigationCategories()
    private var isVisible = false
    private var needContentRefresh = false
    
    @IBOutlet weak var navTable: UITableView!
    var tableAdaptor:MainNavigationTableAdaptor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableAdaptor = MainNavigationTableAdaptor.init(table: self.navTable, navItems: navigationItems, selector: { (destination:NavigationCategory) -> Void in
            self.processController?.executeCommand(.selectCategory(destination))
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = true
        if needContentRefresh {
            navTable.reloadData()
            needContentRefresh = false
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isVisible = false
    }
    
    deinit {
        //print("deallocating NavListViewController")
    }

    func refreshContent() {
        navigationItems.updateSubtitles()
        if isVisible {
            navTable.reloadData()
            needContentRefresh = false
        } else {
            needContentRefresh = true
        }
    }
}
