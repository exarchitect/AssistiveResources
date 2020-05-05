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

    override func createPrimaryViewController() -> UIViewController? {
        let detailsView = OrganizationDetailsView(organization: sharedServices.selections.organization, parentProcessController: self)
        return UIHostingController(rootView: detailsView)
    }

    deinit {
        let _ = 0
        print("deallocating OrganizationdetailPC")
    }
}

