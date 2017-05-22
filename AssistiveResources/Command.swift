//
//  Command.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/15/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import Foundation


struct Command {
    enum CommandType {
        case dismissProcessController(controller: ProcessController)
        case userLoginSuccessful
        case navigationItemSelected(selection:NavigationCategory)
        case eventSelected(event: EntityDescriptor)
        case organizationSelected(organization: EntityDescriptor)
    }
    let type: CommandType
}


