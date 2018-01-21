//
//  NavListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class NavListProcessController: ProcessController {
    
    override func createViewController() -> UIViewController? {
        let navListViewController: NavListViewController? = instantiateViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID")
        navListViewController?.configuration(navDelegate: self.responseDelegate)
        
        return navListViewController
    }

}
