//
//  NavListProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/28/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class NavListProcessController: ProcessController {

    required init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNavigationContent), name: updateNavigationNotificationKeyName, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func createPrimaryViewController() -> UIViewController? {
        let primaryViewController = instantiateProcessViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID")
        primaryViewController?.parentProcessController = self
        return primaryViewController
    }

    @objc func refreshNavigationContent() {
        (primaryViewController as? NavListViewController)?.refreshContent()
    }
}

//MARK: - helper functions

func requestMainNavigationRefresh() {
    NotificationCenter.default.post(name: updateNavigationNotificationKeyName, object: nil)
}
