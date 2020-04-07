//
//  UXUtilities.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/5/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//



import UIKit


func startActivityIndicator(title: String?, message: String?) {

    let presentingController = UIApplication.topViewController()
    
    //create an alert controller
    let pending = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    //create an activity indicator
    let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
    indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    //add the activity indicator as a subview of the alert controller's view
    pending.view.addSubview(indicator)
    indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
    indicator.startAnimating()
  
    presentingController?.present(pending, animated: true, completion: nil)
}

func stopActivityIndicator() {
    
    let presentingController = UIApplication.topViewController()
    presentingController?.dismiss(animated: true, completion: nil)
}


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}


// MARK: - utilities

func instantiateViewController<T>(storyboardName: String, storyboardID: String) -> T? {
    let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
    return viewController as? T
}

func instantiateProcessViewController(storyboardName: String, storyboardID: String) -> ProcessViewController? {
    let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: storyboardID) as? ProcessViewController
}
