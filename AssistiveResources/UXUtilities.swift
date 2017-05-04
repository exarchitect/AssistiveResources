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


enum AppStoryboard : String {
    case Main
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return scene
    }
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
extension UIViewController {
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        return "\(self)"
    }
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}


