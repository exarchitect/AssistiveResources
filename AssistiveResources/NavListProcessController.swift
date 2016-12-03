//
//  NavListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol NavListProcessControllerResponseProtocol {
    func selectedNavigationItem (selection: Destination)
}



class NavListProcessController: ProcessController, NavigationSelectorProtocol {
    
    private var selectorDelegate: NavListProcessControllerResponseProtocol!
    private var userMC: UserModelController!
    private var navigationData: NavigationContent!

    private var navListViewController: NavListViewController!
    private var navCtrller: UINavigationController?
    
    override init() {
        // init ?
        super.init()
    }
    
    func dependencies(userModelController: UserModelController, navSelectorDelegate: NavListProcessControllerResponseProtocol) {
        
        self.selectorDelegate = navSelectorDelegate
        self.userMC = userModelController
    }
    
    func launch(navController: UINavigationController) -> Bool {
        
        precondition(self.selectorDelegate != nil)
        precondition(self.userMC != nil)
        self.navCtrller = navController
        
        self.navigationData = NavigationContent()
        
        self.navListViewController = instantiateViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID") as! NavListViewController
        self.navListViewController.setup(navItems: self.navigationData, selectorDelegate: self)
        
        navController.pushViewController(self.navListViewController, animated: false)
        
        return (self.navListViewController != nil)
    }
    
    override func terminate () {
        let _ = self.navCtrller?.popViewController(animated: true)
    }
    

    
//    func launch(userModelController: UserModelController, navSelectorDelegate: NavigationSelectorProtocol, navController: UINavigationController) -> Bool {
//        
//        self.selectorDelegate = navSelectorDelegate
//        self.userMC = userModelController
//        self.navigationData = NavigationContent()
//        
//        self.navCtrller = navController
//        
//        let authenticationStoryboard: UIStoryboard? = UIStoryboard(name: "NavList", bundle: nil)
//        self.navListViewController = authenticationStoryboard?.instantiateViewController(withIdentifier: "navListStoryboardID") as! NavListViewController
//        self.navListViewController.setup(navItems: self.navigationData, selectorDelegate: self)
//        
//        navController.pushViewController(self.navListViewController, animated: false)
//        
//        return (authenticationStoryboard != nil && self.navListViewController != nil)
//    }
//    
//    func teardown () {
//        let _ = self.navCtrller?.popViewController(animated: true)
//    }

    
    // NavigationSelectorProtocol
    func selectedNavigationItem (selection: Destination) {
        self.selectorDelegate.selectedNavigationItem(selection: selection)
    }
    
}
