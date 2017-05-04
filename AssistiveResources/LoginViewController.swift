//
//  LoginViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol LoginViewControllerCompletionProtocol: class {
    func loginAction (username: String, password: String)
}



class LoginViewController: UIViewController {

    weak private var user: UserModelController?
    weak private var completionProtocol: LoginViewControllerCompletionProtocol!
    @IBOutlet weak var selectLoginType: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var tryoutSubtextLabel: UILabel!
    
    func configuration(userModelController: UserModelController, completionProtocol: LoginViewControllerCompletionProtocol) {
        self.user = userModelController
        self.completionProtocol = completionProtocol
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(self.user != nil)
        precondition(self.completionProtocol != nil)
    }

    // overridden framework methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //freeMemory()
    }
    
    
    // button actions
    @IBAction func loginButtonAction(_ sender: Any) {
        // TODO
        self.completionProtocol?.loginAction(username: "exarchitect@gmail.com", password: "serveme1")
    }

    @IBAction func segmentedControlAction(_ sender: Any) {
        let ctrl:UISegmentedControl = sender as! UISegmentedControl
        
        let isTryout = (ctrl.selectedSegmentIndex == 2)
        self.subtitleLabel.isHidden = isTryout
        self.emailTextField.isHidden = isTryout
        self.passwordTextField.isHidden = isTryout
        self.zipcodeTextField.isHidden = (ctrl.selectedSegmentIndex == 0)
        self.tryoutSubtextLabel.isHidden = !isTryout

        switch ctrl.selectedSegmentIndex {
        case 0:
            self.subtitleLabel.text = "If you have already registered, please enter your email address and password."
        case 1:
            self.subtitleLabel.text = "If you haven't registered, please sign up so that we can customize information for you and your family."
        default:
            self.subtitleLabel.text = "You are welcome to use this app without registering.  We never share your information with any other party."
        }
    }
    
}
