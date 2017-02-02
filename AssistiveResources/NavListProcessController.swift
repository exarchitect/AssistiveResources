//
//  NavListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class NavListProcessController: ProcessController, NavigationSelectorProtocol {
    
    private var navigationDelegate: ProcessControllerProtocol!
    private var user: UserModelController!
    private var navigationData: NavigationContent!

    private var navListViewController: NavListViewController!
    
    init (userModelController: UserModelController, responseDelegate: ProcessControllerProtocol) {
        
        self.navigationDelegate = responseDelegate
        self.user = userModelController
    }
    
    override func launch() -> Bool {
        
        precondition(self.navigationDelegate != nil)
        precondition(self.user != nil)
        
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
        let cmd = Command(type: .navigationItemSelected(selection: selection))
        self.navigationDelegate.requestAction(command: cmd)
    }
    
}
