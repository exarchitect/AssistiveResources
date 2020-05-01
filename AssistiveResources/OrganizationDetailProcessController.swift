//
//  OrganizationDetailProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 4/28/20.
//  Copyright © 2020 SevenPlusTwo. All rights reserved.
//

import UIKit
import SwiftUI

class OrganizationDetailProcessController: ProcessController {

    var organization: OrganizationDescriptor?

    override func createPrimaryViewController() -> UIViewController? {
        let organization = OrganizationDescriptor(name: "Easter Deals", identifier: 416462)
        let detailsView = OrganizationDetailsView(organization: organization, parentProcessController: self)
        return UIHostingController(rootView: detailsView)
    }

    deinit {
        let _ = 0
        print("deallocating OrganizationdetailPC")
    }
}

