//
//  NavListViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol NavigationSelectorProtocol {
    func selectedNavigationItem (selection: Destination)
}


class NavListViewController: UIViewController {
//class NavListViewController: UIViewController, MainNavTableAdaptorNotificationProtocol {

    private var selectorDelegate: NavigationSelectorProtocol?
    
    @IBOutlet weak var navTable: UITableView!
    var tableAdaptor:MainNavigationTableAdaptor?

    func setup(selectorDelegate: NavigationSelectorProtocol) {
        self.selectorDelegate = selectorDelegate
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableAdaptor = MainNavigationTableAdaptor.init(table: self.navTable, selector: { (destination:Destination) -> Void in
            
            self.selectorDelegate?.selectedNavigationItem(selection: destination)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    func notifyRowSelected(dest: Destination) {
//        self.completionDelegate?.selectedNavigationItem(selection: dest)
//    }
//    
//    func notifyRowDeleted(rowIndex: Int) {
//        
//    }
    
}
