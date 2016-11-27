//
//  ResourcesModelController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

class ResourcesModelController: NSObject {
    
    //    var organizationRepo : OrganizationRepository!
    //    var eventRepo : EventRepository!
    
    override init()
    {
        super.init()
        
        //        organizationRepo = OrganizationRepository()
        //        eventRepo = EventRepository()
    }
    
    func loadResources() {
        // load from remote
    }
    
}


func initializeRemoteDatabase() {
    let APP_ID = "A9F4E1E9-EE0E-C611-FF91-4B3E52A79900"     // SwiftNeed
    let SECRET_KEY = "91933CE7-53FE-117C-FFC0-E9A8751F9800"
    let VERSION_NUM = "v1"

    let backendless = Backendless.sharedInstance()

    backendless?.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
    
}

