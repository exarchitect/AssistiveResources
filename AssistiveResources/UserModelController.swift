//
//  UserModelController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/21/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


enum LoginType : Int {
    case None = 0, Anonymous = 1, Authenticated = 2
}


typealias AsyncCompletionHandlerType = (_ success: Bool) -> Void


final class UserModelController: NSObject {
    
    var isUserAuthenticated: Bool
    var rememberMe: Bool
    
    private var completionClosure: AsyncCompletionHandlerType?
    private var username: String = ""
    private var password: String = ""
    private var loginType: LoginType = LoginType.None
    
    private var backendlUser: BackendlessUser? = nil
    
    static let sharedInstance = UserModelController()     // singleton
    
    override init() {
        isUserAuthenticated = false
        
        let props = PropertySettings.sharedInstance
        props.read()
        username = props.username
        password = props.password
        rememberMe = props.rememberMe
        
        super.init()
    }
    
    func haveCredentials() -> Bool {
        return (!self.username.isEmpty && !self.password.isEmpty)
    }
    
    func authorizeUser (completion: @escaping AsyncCompletionHandlerType) {
        completionClosure = completion
        
        if (self.haveCredentials()) {
            let backend = Backendless.sharedInstance()
            
            backend?.userService.login(username, password: password, response: { (user: BackendlessUser?) in
                self.backendlUser = user
                self.isUserAuthenticated = true
                self.completionClosure?(true)
                self.completionClosure = nil
            }, error: { (fault: Fault?) in
                self.isUserAuthenticated = false
                print (fault ?? "failed login")
                self.completionClosure?(false)
                self.completionClosure = nil
            })
        } else {
            self.completionClosure?(false)      // failed, since we dont have creds
        }
        
    }
    
    func logout() {
        let backend = Backendless.sharedInstance()
        backend?.userService.logout({ (user: Any?) in
            print ("logged out")
        }, error: { (fault: Fault?) in
            print (fault ?? "failed logoff")
        })
        
    }

    private func storeUserCredentials (username: String, password: String) {
        self.username = username
        self.password = password
        
        let props = PropertySettings.sharedInstance
        props.username = username
        props.password = password
        props.write()
    }
    
}
