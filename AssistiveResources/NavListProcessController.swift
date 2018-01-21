//
//  NavListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class NavListProcessController: ProcessController {
    
//    typealias ExternalDependencies = UserProvider
//
//    private let dependencies: ExternalDependencies
//    private var navigationData: NavigationContent!
    
    // ---------------------------------------------------------------
//    init(responseDelegate: ProcessControllerResponseProtocol, navigationController: UINavigationController, services: SharedServices) {
//        //self.dependencies = dependencies
//
//        //precondition(dependencies.userModelController != nil)
//        self.navigationData = NavigationContent()
//
//        super.init(responseDelegate: responseDelegate, navController: navigationController, services: services)
//    }

    // ---------------------------------------------------------------
//    override func createViewController() -> UIViewController? {
//        var navListViewController: NavListViewController?
//
//        //navListViewController = instantiateViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID") as! NavListViewController
//        navListViewController = instantiateTypedViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID")
//        navListViewController?.configuration(navDelegate: self.responseDelegate)
//
//        return navListViewController
//    }
    
    override func createViewController() -> UIViewController? {
        let navListViewController: NavListViewController? = instantiateTypedViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID")
        navListViewController?.configuration(navDelegate: self.responseDelegate)
        
        return navListViewController
    }

}
