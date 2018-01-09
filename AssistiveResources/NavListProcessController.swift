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
    
    init(responseDelegate: ProcessControllerResponseHandler, navigationController: UINavigationController, dependencies: ExternalDependencies) {
        self.dependencies = dependencies
        super.init(responseDelegate: responseDelegate, navController: navigationController)
    }

    override func launch() {
        var navListViewController: NavListViewController
        
        precondition(self.dependencies.userModelController != nil)
        self.navigationData = NavigationContent()
        
        navListViewController = instantiateViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID") as! NavListViewController
        navListViewController.configuration(navItems: self.navigationData, navDelegate: self)
        
        self.primaryViewController = navListViewController
        super.launch()
    }
    
    //MARK:- NavigationSelectorProtocol
    
    func selectNavigationItem (selection: NavigationCategory) {
        let cmd = Command(type: .navigationItemSelected(selection: selection))
        self.responseDelegate.requestAction(command: cmd)
    }
    
}
