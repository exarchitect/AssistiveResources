//
//  NavListViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol NavListViewControllerCompletionProtocol {
    func selectedNavigationItem (selection: Destination)
}


class NavListViewController: UIViewController, MainNavTableAdaptorNotificationProtocol {

    private var completionDelegate: NavListViewControllerCompletionProtocol?
    
    @IBOutlet weak var navTable: UITableView!
    var tableAdaptor:MainNavigationTableAdaptor?

    func setup(completionProtocol: NavListViewControllerCompletionProtocol) {
        self.completionDelegate = completionProtocol
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableAdaptor = MainNavigationTableAdaptor.init(table: self.navTable, delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func navSelectionAction () {
        
    }

    //MARK: tableView delegate
    
//    func notifyRowSelected(dest: Destination) {
//        switch dest {
//        case Destination.Organizations:
//            let _ = 7
//            
//        case Destination.Events:
//            performSegue(withIdentifier: "showMainEvent", sender: self)
//            
//        case Destination.Facilities:
//            let _ = 7
//            
//        case Destination.Travel:
//            let _ = 7
//            
//        case Destination.News:
//            let _ = 7
//            
//        case Destination.Inbox:
//            let _ = 7
//            
//        case Destination.Profile:
//            // TEMP
//            let _ = 7
//            //let user = AuthenticatedUser.sharedInstance
//            //AuthenticatedUser.sharedInstance.logout()
//        }
//        
//    }
    func notifyRowSelected(dest: Destination) {
        self.completionDelegate?.selectedNavigationItem(selection: dest)
    }
    
    func notifyRowDeleted(rowIndex: Int) {
        
    }
    
}
