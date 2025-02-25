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

    func setup(completionProtocol: LoginViewControllerCompletionProtocol) {
        self.completionProtocol = completionProtocol
    }
    

    // overridden framework methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // button actions
    @IBAction func loginButtonAction(_ sender: Any) {
        self.completionProtocol?.loginAction(username: "", password: "")
        
    }

}
