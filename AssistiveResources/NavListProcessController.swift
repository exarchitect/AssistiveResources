//
//  NavListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class NavListProcessController: ProcessController {
    
    override func createPrimaryViewController() -> ProcessViewController? {
        let navListViewController: NavListViewController? = instantiateViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID")
        navListViewController?.configuration()
        
        return navListViewController
    }

}
