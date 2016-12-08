//
//  NavListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol NavListProcessControllerResponseProtocol {
    func notifyNavigationItemSelected (selection: Destination)
}



class NavListProcessController: ProcessController, NavigationSelectorProtocol {
    
    private var selectorDelegate: NavListProcessControllerResponseProtocol!
    private var usrModelController: UserModelController!
    private var navigationData: NavigationContent!

    private var navListViewController: NavListViewController!
    private var navCtrller: UINavigationController?
    
    override init() {
        // init ?
        super.init()
    }
    
    func dependencies(userModelController: UserModelController, navSelectorDelegate: NavListProcessControllerResponseProtocol) {
        
        self.selectorDelegate = navSelectorDelegate
        self.usrModelController = userModelController
    }
    
    func launch(navController: UINavigationController) -> Bool {
        
        precondition(self.selectorDelegate != nil)
        precondition(self.usrModelController != nil)
        self.navCtrller = navController
        
        self.navigationData = NavigationContent()
        
        self.navListViewController = instantiateViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID") as! NavListViewController
        self.navListViewController.dependencies(navItems: self.navigationData, selectorDelegate: self)
        
        navController.pushViewController(self.navListViewController, animated: false)
        
        return (self.navListViewController != nil)
    }
    
    override func terminate () {
        super.terminate()
        let _ = self.navCtrller?.popViewController(animated: true)
    }
    
    override func topViewController() -> UIViewController {
        return self.navListViewController
    }

    // NavigationSelectorProtocol
    func selectNavigationItem (selection: Destination) {
        self.selectorDelegate.notifyNavigationItemSelected(selection: selection)
    }
    
}
