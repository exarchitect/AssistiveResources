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



protocol ProcessControllerCompletionProtocol {
    func completionAction (action: ProcessCompletionAction, teardown: ProcessCompletionDisposition) -> Bool
}



class ProcessController: NSObject {

}
