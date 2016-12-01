//
//  NavListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

protocol NavListCompletionProtocol {
    func navListAction (selection: Destination)
}


class NavListProcessController: ProcessController, NavListViewControllerCompletionProtocol {
    
    private var responseDelegate: NavListCompletionProtocol!
    private var userMC: UserModelController!
    private var navListViewController: NavListViewController!
    
    private var navCtrller: UINavigationController?
    
    override init() {
        
        // init ?
        
        super.init()
    }
    
    func launch(userModelController: UserModelController, navListResponseDelegate: NavListCompletionProtocol, navController: UINavigationController) -> Bool {
        
        self.responseDelegate = navListResponseDelegate
        self.userMC = userModelController
        self.navCtrller = navController
        
        let authenticationStoryboard: UIStoryboard? = UIStoryboard(name: "NavList", bundle: nil)
        self.navListViewController = authenticationStoryboard?.instantiateViewController(withIdentifier: "navListStoryboardID") as! NavListViewController
        self.navListViewController.setup(completionProtocol: self)
        
        navController.pushViewController(self.navListViewController, animated: true)
        
        return (authenticationStoryboard != nil && self.navListViewController != nil)
    }
    
    func teardown () {
        let _ = self.navCtrller?.popViewController(animated: true)
    }
    
    // ?Protocol
    func selectedNavigationItem (selection: Destination) {
        self.responseDelegate.navListAction(selection: selection)
    }
    
}
