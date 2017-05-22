//
//  NavListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class NavListProcessController: ProcessController, NavigationSelectorProtocol {
    
    typealias Dependencies = UserProvider
    
    private let dependencies: Dependencies
    private var navigationData: NavigationContent!

    private var navListViewController: NavListViewController!
    
    init(responseDelegate: ProcessControllerProtocol, dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(responseDelegate: responseDelegate)
    }

    override func launch() -> Bool {
        
        precondition(self.responseDelegate != nil)
        precondition(self.dependencies.userModelController != nil)
        
        self.navigationData = NavigationContent()
        
        self.navListViewController = instantiateViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID") as! NavListViewController
        self.navListViewController.configuration(navItems: self.navigationData, navDelegate: self)
        
        let navCtrller = self.responseDelegate.navigationController()
        navCtrller.pushViewController(self.navListViewController, animated: false)
        
        return (self.navListViewController != nil)
    }
    
    override func terminate () {
        super.terminate()

        let navCtrller = self.responseDelegate.navigationController()
        let _ = navCtrller.popViewController(animated: true)
    }
    
    // NavigationSelectorProtocol
    func selectNavigationItem (selection: NavigationCategory) {
        let cmd = Command(type: .navigationItemSelected(selection: selection))
        self.responseDelegate.requestAction(command: cmd)
    }
    
}
