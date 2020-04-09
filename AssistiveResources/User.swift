//
//  User.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 4/2/20.
//  Copyright © 2020 SevenPlusTwo. All rights reserved.
//

import UIKit


enum LoginResponse {
    case authenticated, unknown, needCredentials
}

enum UserAccess {
    case anonymous, identified, pendingSignup
}

typealias LoginCompletionHandlerType = (_ loginResult: LoginResponse) -> Void

final class User: NSObject {

    var locationProfile: LocationProfile
    var locationZip: String = ""
    private var username: String = ""
    private var password: String = ""

    private var rememberMe: Bool
    private var loginType: UserAccess?
    private var backendlUser: BackendlessUser? = nil
    static let sharedInstance = User()

    override init() {
        let props = PropertySettings.sharedInstance
        props.read()
        username = props.username ?? ""
        password = props.password ?? ""
        rememberMe = props.rememberMe

        locationZip = props.zipcode
        locationProfile = LocationProfile(zip: self.locationZip)

        super.init()
    }

    func validateCredentials(completion: @escaping LoginCompletionHandlerType) {
        guard haveCredentials() else {
            self.loginType = nil
            // temp
            self.storeUserCredentials (username: "exarchitect", password: "whatever**@^")
            completion(.needCredentials)      // failed, since we dont have creds
            return
        }
        DispatchQueue.main.async {
            startActivityIndicator(title: nil, message: "authenticating...")
        }

        Backendless.sharedInstance()?.userService.login(username, password: password, response: { (user: BackendlessUser?) in
            self.backendlUser = user
            self.storeUserCredentials(username: self.username, password: self.password)

            stopActivityIndicator()

            // temp
            self.storeUserCredentials (username: "exarchitect", password: "whatever**@^")

            self.loginType = .identified
            completion(.authenticated)

        }, error: { (fault: Fault?) in
            print (fault ?? "failed login")
            let err: String = fault!.faultCode
            if err=="-1009" {
                self.loginType = .anonymous        // TODO: if system comes back online, re-authorize user
            } // else no access 

            // temp
            self.loginType = .identified

            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 0.5)) {
                stopActivityIndicator()
                // temp
                completion(.authenticated)
            }
        })
    }

    func logout() {
        let backend = Backendless.sharedInstance()
        backend?.userService.logout({ () in
            print ("logged out")
        }, error: { (fault: Fault?) in
            print (fault ?? "failed logoff")
        })

    }

    private func haveCredentials() -> Bool {
        return (!self.username.isEmpty && !self.password.isEmpty)
    }

    func storeUserCredentials (username: String, password: String) {
        self.username = username
        self.password = password

        let props = PropertySettings.sharedInstance
        props.username = username
        props.password = password
        props.write()
    }

}
