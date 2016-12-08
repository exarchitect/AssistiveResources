//
//  LoginViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol LoginViewControllerCompletionProtocol {
    func loginAction (username: String, password: String)
}



class LoginViewController: UIViewController {

    private var completionProtocol: LoginViewControllerCompletionProtocol?

    func dependencies(completionProtocol: LoginViewControllerCompletionProtocol) {
        self.completionProtocol = completionProtocol
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(self.completionProtocol != nil)
    }

    // overridden framework methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        freeMemory()
    }
    
    
    // button actions
    @IBAction func loginButtonAction(_ sender: Any) {
        self.completionProtocol?.loginAction(username: "", password: "")
        
    }

}
