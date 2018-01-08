//
//  NavListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class NavListProcessController: ProcessController, NavigationSelectorProtocol {
    
    typealias ExternalDependencies = UserProvider
    
    private let dependencies: ExternalDependencies
    private var navigationData: NavigationContent!

    private var navListViewController: NavListViewController!
    
    init(responseDelegate: ProcessControllerResponseHandler, dependencies: ExternalDependencies) {
        self.dependencies = dependencies
        super.init(responseDelegate: responseDelegate)
    }

    override func launch(navController: UINavigationController) -> Bool {
        
        precondition(self.dependencies.userModelController != nil)
        
        self.navigationData = NavigationContent()
        
        self.navListViewController = instantiateViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID") as! NavListViewController
        self.navListViewController.configuration(navItems: self.navigationData, navDelegate: self)
        
        navController.pushViewController(self.navListViewController, animated: false)

        return (self.navListViewController != nil)
    }
    
    override func terminate (navController: UINavigationController) {
        super.terminate(navController: navController)

        let _ = navController.popViewController(animated: true)
    }
    
    // NavigationSelectorProtocol
    func selectNavigationItem (selection: NavigationCategory) {
        let cmd = Command(type: .navigationItemSelected(selection: selection))
        self.responseDelegate.requestAction(command: cmd)
    }
    
}
