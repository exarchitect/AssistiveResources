//
//  ProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


enum ProcessCompletionAction : String {
    case selectEvent, selectOrg
}


enum ProcessCompletionDisposition : String {
    case close, remainOpen
}



//protocol ProcessControllerCompletionProtocol {
//    func completionAction (action: ProcessCompletionAction, teardown: ProcessCompletionDisposition) -> Bool
//}


class ProcessController: NSObject {
    
    var inUse: Bool = false

    override init() {
        self.inUse = true
        super.init()
    }

    func terminate () {
        self.inUse = false
    }
    
    func topViewController () -> UIViewController {
        assert(false)   // must be overridden or will assert at runtime
    }
    
}


func instantiateViewController(storyboardName: String, storyboardID: String) -> UIViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
    return viewController
}
