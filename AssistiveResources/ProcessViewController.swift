//
//  ProcessViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/21/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import UIKit

class ProcessViewController: UIViewController {

    weak var processController: ProcessController?

    func execute(command: AssistiveCommand){
        processController?.commandHandler.execute(command: command)
    }

}
