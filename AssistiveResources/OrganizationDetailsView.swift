//
//  OrganizationDetailsView.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/1/20.
//  Copyright © 2020 SevenPlusTwo. All rights reserved.
//

import UIKit
import SwiftUI

struct OrganizationDetailsView: View {
    var organization: OrganizationDescriptor?
    var parentProcessController: ProcessController?

    var body: some View {
        let view = NavigationView {
            VStack {
                Button(action: {
                    self.parentProcessController?.executeCommand(.dismissCurrentProcess)
                }) {
                    Text(verbatim: "Back")
                }
                ScrollView {
                    VStack {
                        Text(verbatim: organization?.name ?? "no org available")
                            .font(Font.largeTitle)
                            .multilineTextAlignment(.leading)
                        Text(verbatim: "Org detail")
                            .font(Font.body)
                    }
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        return view
    }
}
