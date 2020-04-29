//
//  OrganizationDetailProcessController.swift
//  AssistiveResources
//
//  Created by WCJ on 4/28/20.
//  Copyright © 2020 SevenPlusTwo. All rights reserved.
//

import UIKit
import SwiftUI

class OrganizationDetailProcessController: ProcessController {

    var organization: OrganizationDescriptor?

    override func createPrimaryViewController() -> UIViewController? {
        let vc = UIHostingController(rootView: Text("Hello World"))
        return nil
    }

    deinit {
        let _ = 0
        print("deallocating OrganizationdetailPC")
    }
}
