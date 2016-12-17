//
//  NavListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol NavListProcessControllerResponseProtocol: ProcessControllerProtocol {
    func notifyNavigationItemSelected (selection: Destination)
}



class NavListProcessController: ProcessController, NavigationSelectorProtocol {
    
    private var selectorDelegate: NavListProcessControllerResponseProtocol!
    private var usrModelController: UserModelController!
    private var navigationData: NavigationContent!

    private var navListViewController: NavListViewController!
    
    override init() {
        // init ?
        super.init()
    }
    
    func dependencies(userModelController: UserModelController, navSelectorDelegate: NavListProcessControllerResponseProtocol) {
        
        self.selectorDelegate = navSelectorDelegate
        self.usrModelController = userModelController
    }
    
    func launch() -> Bool {
        
        precondition(self.selectorDelegate != nil)
        precondition(self.usrModelController != nil)
        
        self.navigationData = NavigationContent()
        
        self.navListViewController = instantiateViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID") as! NavListViewController
        self.navListViewController.dependencies(navItems: self.navigationData, selectorDelegate: self)
        
        let navCtrller = self.selectorDelegate.navigationController()
        navCtrller.pushViewController(self.navListViewController, animated: false)
        
        return (self.navListViewController != nil)
    }
    
    override func terminate () {
        super.terminate()

        let navCtrller = self.selectorDelegate.navigationController()
        let _ = navCtrller.popViewController(animated: true)
    }
    
    // NavigationSelectorProtocol
    func selectNavigationItem (selection: Destination) {
        self.selectorDelegate.notifyNavigationItemSelected(selection: selection)
    }
    
}
