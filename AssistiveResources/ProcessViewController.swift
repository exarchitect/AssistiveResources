//
//  ProcessViewController.swift
//  AssistiveResources
//
//  Created by WCJ on 1/21/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import UIKit

class ProcessViewController: UIViewController {

    weak var processController: ProcessController?

    func requestAction (command: AssistiveCommand){
        processController?.commandHandler.invokeAction(command: command)
    }

}
