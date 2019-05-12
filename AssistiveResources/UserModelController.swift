//
//  UserModelController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/21/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


enum LoginType : Int {
    case Uninitialized = 0, Anonymous = 1, Authenticated = 2, Rejected = 3, NoCredentials = 4//, ServiceOffline = 5
}


typealias AsyncCompletionHandlerType = (_ loginResult: LoginType) -> Void


protocol UserProvider {
    var userModelController: UserModelController! { get }
}


final class UserModelController: ModelController {
    
    var locationProfile: LocationProfile
    var locationZip: String = ""
    
    private var rememberMe: Bool
    
    private var completionClosure: AsyncCompletionHandlerType?
    private var username: String = ""
    private var password: String = ""
    private var loginType: LoginType = LoginType.Uninitialized
    
    private var backendlUser: BackendlessUser? = nil
    
    static let sharedInstance = UserModelController()     // singleton
    
    override init() {
        let props = PropertySettings.sharedInstance
        props.read()
        self.username = props.username ?? ""
        self.password = props.password ?? ""
        self.rememberMe = props.rememberMe
        
        self.locationZip = props.zipcode
        self.locationProfile = LocationProfile(zip: self.locationZip)
        
        super.init()
    }
    
    func haveCredentials() -> Bool {
        return (!self.username.isEmpty && !self.password.isEmpty)
    }
    
    func authorizeUser (completion: @escaping AsyncCompletionHandlerType) {
        completionClosure = completion

        DispatchQueue.main.async {
            startActivityIndicator(title: nil, message: "authenticating...")
        }
        let backend = Backendless.sharedInstance()

        if (self.haveCredentials()) {
            
            backend?.userService.login(username, password: password, response: { (user: BackendlessUser?) in
                self.backendlUser = user
                self.storeUserCredentials(username: self.username, password: self.password)
                
                stopActivityIndicator()
                
                self.loginType = LoginType.Authenticated
                self.completionClosure?(self.loginType)
                self.completionClosure = nil
                
            }, error: { (fault: Fault?) in
                print (fault ?? "failed login")
                let err: String = fault!.faultCode
                if err=="-1009" {
                    self.loginType = LoginType.Anonymous        // TODO: if system comes back online, re-authorize user
                } else {
                    self.loginType = LoginType.Rejected
                }
                
                DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 0.1)) {
                    stopActivityIndicator()
                    self.completionClosure?(self.loginType)
                    self.completionClosure = nil
                }
                
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 1.1)) {
                stopActivityIndicator()
                
                self.loginType = LoginType.NoCredentials
                self.completionClosure?(self.loginType)      // failed, since we dont have creds
                self.completionClosure = nil
            }
        }
        
    }
    
    func logout() {
        let backend = Backendless.sharedInstance()
        backend?.userService.logout({ () in
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
