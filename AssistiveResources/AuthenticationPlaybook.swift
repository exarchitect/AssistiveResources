//
//  AuthenticationPlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 4/3/20.
//  Copyright © 2020 SevenPlusTwo. All rights reserved.
//

import Foundation

struct Credentials {
    var userName: String
    var password: String
}

enum LoginResponse {
    case authenticated, unknown, needCredentials
}

enum UserAccess {
    case anonymous, identified, pendingSignup
}

