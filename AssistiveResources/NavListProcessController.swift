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
    
    init(responseDelegate: ProcessControllerResponseHandler, navigationController: UINavigationController, dependencies: ExternalDependencies) {
        self.dependencies = dependencies
        super.init(responseDelegate: responseDelegate, navController: navigationController)
    }

    override func launch() -> Bool {
        
        precondition(self.dependencies.userModelController != nil)
        
        self.navigationData = NavigationContent()
        
        self.navListViewController = instantiateViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID") as! NavListViewController
        self.navListViewController.configuration(navItems: self.navigationData, navDelegate: self)
        
        self.navigationController.pushViewController(self.navListViewController, animated: false)

        return (self.navListViewController != nil)
    }
    
    override func terminate () {
        super.terminate()

        let _ = self.navigationController.popViewController(animated: true)
        
        self.navListViewController = nil
    }
    
    // NavigationSelectorProtocol
    func selectNavigationItem (selection: NavigationCategory) {
        let cmd = Command(type: .navigationItemSelected(selection: selection))
        self.responseDelegate.requestAction(command: cmd)
    }
    
}
