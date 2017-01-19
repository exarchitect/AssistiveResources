//
//  UXUtilities.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/5/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


//func createActivityIndicator (view: UIView) -> UIActivityIndicatorView {
//    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
//    indicator.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
//    indicator.center = view.center
//    view.addSubview(indicator)
//    indicator.bringSubview(toFront: view)
//    UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    
//    return indicator
//}
//
//func startActivityIndicator (indicator: UIActivityIndicatorView) {
//    indicator.startAnimating()
//}
//
//func stopActivityIndicator (indicator: UIActivityIndicatorView) {
//    indicator.stopAnimating()
//    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//}


func startActivityIndicator(title: String?, message: String?) {
    //func startBackgroundActivityAlert(presentingController: UIViewController, title: String?, message: String?) {
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
    //func stopBackgroundActivityAlert(presentingController: UIViewController) {
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

