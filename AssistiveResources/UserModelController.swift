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


final class UserModelController: ModelController {
    
    var isUserAuthenticated: Bool
    var location: LocationProfile
    
    private var rememberMe: Bool
    
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
        self.username = props.username
        self.password = props.password
        self.rememberMe = props.rememberMe
        
        self.location = LocationProfile(zip: "00000")
        
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
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 1.1)) {
                self.completionClosure?(false)      // failed, since we dont have creds
            }
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

    func storeUserCredentials (username: String, password: String) {
        self.username = username
        self.password = password
        
        let props = PropertySettings.sharedInstance
        props.username = username
        props.password = password
        props.write()
    }
    
}
