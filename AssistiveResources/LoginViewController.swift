//
//  LoginViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/23/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, ViewControllable {

    weak var parentProcessController: ProcessController?
    var accessType: UserAccess = .identified

    var authenticator: AuthenticationHandler? {
        parentProcessController as? AuthenticationHandler
    }

    @IBOutlet weak var selectLoginType: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tryoutSubtextLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // addl tasks
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
        switch accessType {
        case .identified:
            // TODO: need real credential values
            authenticator?.userEnteredCredentials(Credentials(userName: "exarchitect@gmail.com", password: "alongishpassword"))
        case .pendingSignup:
            guard let zipText = zipcodeTextField.text, Int(zipText) != nil, zipText.count == 5 else {
                // warn invalid zip
                return
            }
            // TODO: need real credential values
            authenticator?.userSignupRequest(credentials: Credentials(userName: "exarchitect@gmail.com", password: "alongishpassword"), location: LocationProfile(zip: zipText))
        case .anonymous:
            guard let zipText = zipcodeTextField.text, Int(zipText) != nil, zipText.count == 5 else {
                // warn invalid zip
                return
            }
            authenticator?.userGuestAccessRequest(location: LocationProfile(zip: zipText))
        }
    }

    @IBAction func segmentedControlAction(_ sender: Any) {
        guard let ctrl = sender as? UISegmentedControl else {
            return
        }

        switch ctrl.selectedSegmentIndex {
        case 0:
            accessType = .identified
            subtitleLabel.text = "If you have already registered, please enter your email address and password."
        case 1:
            accessType = .pendingSignup
            subtitleLabel.text = "If you haven't registered, please sign up so that we can customize information for you and your family."
        default:
            accessType = .anonymous
            subtitleLabel.text = "You are welcome to use this app without registering.  We never share your information with any other party."
        }

        subtitleLabel.isHidden = accessType == .anonymous
        emailTextField.isHidden = accessType == .anonymous
        passwordTextField.isHidden = accessType == .anonymous
        zipcodeTextField.isHidden = accessType == .identified
        tryoutSubtextLabel.isHidden = accessType != .anonymous
    }
}
