//
//  ProcessViewController.swift
//  AssistiveResources
//
//  Created by WCJ on 1/21/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import UIKit

class ProcessViewController: UIViewController {

    private weak var commandDelegate:CommandResponseProtocol!

    func setupDelegate(selectorDelegate: CommandResponseProtocol) {
        self.commandDelegate = selectorDelegate
    }
    
    func requestAction (command: AssistiveCommand){
        self.commandDelegate.invokeAction(command: command)
    }

}
