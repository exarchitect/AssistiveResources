//
//  LoginViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class LoginViewController: ProcessViewController {

    var user: User? {
        parentProcessController?.sharedServices.userModel
    }
    var authenticationDelegate: AuthenticationProtocol? {
        parentProcessController as? AuthenticationProtocol
    }

    @IBOutlet weak var selectLoginType: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tryoutSubtextLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(user != nil)
        precondition(authenticationDelegate != nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //freeMemory()
    }
    
    deinit {
        print("deallocating LoginViewController")
    }
    
    //MARK:-  IBActions
    
    @IBAction func loginButtonAction(_ sender: Any) {
        // TODO:
        authenticationDelegate?.userEnteredCredentials(loginType: .identified, credentials: Credentials(userName: "exarchitect@gmail.com", password: "alongishpassword"))
    }

    @IBAction func segmentedControlAction(_ sender: Any) {
        guard let ctrl = sender as? UISegmentedControl else {
            return
        }

        let isTryout = (ctrl.selectedSegmentIndex == 2)
        subtitleLabel.isHidden = isTryout
        emailTextField.isHidden = isTryout
        passwordTextField.isHidden = isTryout
        zipcodeTextField.isHidden = (ctrl.selectedSegmentIndex == 0)
        tryoutSubtextLabel.isHidden = !isTryout

        switch ctrl.selectedSegmentIndex {
        case 0:
            subtitleLabel.text = "If you have already registered, please enter your email address and password."
        case 1:
            subtitleLabel.text = "If you haven't registered, please sign up so that we can customize information for you and your family."
        default:
            subtitleLabel.text = "You are welcome to use this app without registering.  We never share your information with any other party."
        }
    }
    
}
