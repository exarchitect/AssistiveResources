//
//  NavListViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol NavListViewControllerCompletionProtocol {
    func navAction (selection: TopDestination)
}


class NavListViewController: UIViewController, MainNavTableAdaptorNotificationProtocol {

    private var completionProtocol: NavListViewControllerCompletionProtocol?
    
    @IBOutlet weak var navTable: UITableView!
    var tableAdaptor:MainNavigationTableAdaptor?

    func setup(completionProtocol: NavListViewControllerCompletionProtocol) {
        self.completionProtocol = completionProtocol
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
    
    func notifyRowSelected(dest: Destination) {
        switch dest {
        case Destination.Organizations:
            let _ = 7
            
        case Destination.Events:
            performSegue(withIdentifier: "showMainEvent", sender: self)
            
        case Destination.Facilities:
            let _ = 7
            
        case Destination.Travel:
            let _ = 7
            
        case Destination.News:
            let _ = 7
            
        case Destination.Inbox:
            let _ = 7
            
        case Destination.Profile:
            // TEMP
            let _ = 7
            //let user = AuthenticatedUser.sharedInstance
            //AuthenticatedUser.sharedInstance.logout()
        }
        
    }
    
    func notifyRowDeleted(rowIndex: Int) {
        
    }
    
}
