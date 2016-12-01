//
//  NavListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class NavListProcessController: ProcessController, NavigationSelectorProtocol {
    
    private var selectorDelegate: NavigationSelectorProtocol!
    private var userMC: UserModelController!
    private var navListViewController: NavListViewController!
    
    private var navCtrller: UINavigationController?
    
    override init() {
        
        // init ?
        
        super.init()
    }
    
    func launch(userModelController: UserModelController, navSelectorDelegate: NavigationSelectorProtocol, navController: UINavigationController) -> Bool {
        
        self.selectorDelegate = navSelectorDelegate
        self.userMC = userModelController
        self.navCtrller = navController
        
        let authenticationStoryboard: UIStoryboard? = UIStoryboard(name: "NavList", bundle: nil)
        self.navListViewController = authenticationStoryboard?.instantiateViewController(withIdentifier: "navListStoryboardID") as! NavListViewController
        self.navListViewController.setup(selectorDelegate: self)
        
        navController.pushViewController(self.navListViewController, animated: true)
        
        return (authenticationStoryboard != nil && self.navListViewController != nil)
    }
    
    func teardown () {
        let _ = self.navCtrller?.popViewController(animated: true)
    }
    
    // NavigationSelectorProtocol
    func selectedNavigationItem (selection: Destination) {
        self.selectorDelegate.selectedNavigationItem(selection: selection)
    }
    
}
