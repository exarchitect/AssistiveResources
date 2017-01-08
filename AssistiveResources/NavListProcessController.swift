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
    
    private var navigationDelegate: NavListProcessControllerResponseProtocol!
    private var usrModelController: UserModelController!
    private var navigationData: NavigationContent!

    private var navListViewController: NavListViewController!
    
    init (userModelController: UserModelController, navDelegate: NavListProcessControllerResponseProtocol) {
        
        self.navigationDelegate = navDelegate
        self.usrModelController = userModelController
    }
    
    func launch() -> Bool {
        
        precondition(self.navigationDelegate != nil)
        precondition(self.usrModelController != nil)
        
        self.navigationData = NavigationContent()
        
        self.navListViewController = instantiateViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID") as! NavListViewController
        self.navListViewController.dependencies(navItems: self.navigationData, navDelegate: self)
        
        let navCtrller = self.navigationDelegate.navigationController()
        navCtrller.pushViewController(self.navListViewController, animated: false)
        
        return (self.navListViewController != nil)
    }
    
    override func terminate () {
        super.terminate()

        let navCtrller = self.navigationDelegate.navigationController()
        let _ = navCtrller.popViewController(animated: true)
    }
    
    // NavigationSelectorProtocol
    func selectNavigationItem (selection: Destination) {
        self.navigationDelegate.notifyNavigationItemSelected(selection: selection)
    }
    
}
