//
//  ProcessViewController.swift
//  AssistiveResources
//
//  Created by WCJ on 1/21/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import UIKit

class ProcessViewController: UIViewController {

    weak var commandDelegate:ProcessControllerResponseProtocol!

    func setupDelegate(selectorDelegate: ProcessControllerResponseProtocol) {
        self.commandDelegate = selectorDelegate
    }
    
    func requestAction (command: AssistiveCommand){
        self.commandDelegate.requestAction(command: command)
    }

}
