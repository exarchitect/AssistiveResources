//
//  DataService.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/16/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

class DataService: NSObject {
    
    private let APP_ID = "A9F4E1E9-EE0E-C611-FF91-4B3E52A79900"     // SwiftNeed
    private let SECRET_KEY = "91933CE7-53FE-117C-FFC0-E9A8751F9800"
    private let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
//    var organizationRepo : OrganizationRepository!
//    var eventRepo : EventRepository!
    
    override init()
    {
        super.init()

        self.backendless?.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
//        organizationRepo = OrganizationRepository()
//        eventRepo = EventRepository()
    }
    
    func loadServices() {
        // load from remote
    }
    
}
