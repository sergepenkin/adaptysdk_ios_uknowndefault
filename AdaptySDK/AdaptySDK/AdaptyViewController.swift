//
//  AdaptyViewController.swift
//  AdaptySDK
//
//  Created by mac on 27.12.2024.
//
import Foundation
import UIKit

internal import Adapty
internal import AdaptyUI

extension UIApplication {
    func topViewController() -> UIViewController? {
        var topViewController: UIViewController? = nil
        if #available(iOS 13, *) {
            for scene in connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        if window.isKeyWindow {
                            topViewController = window.rootViewController
                        }
                    }
                }
            }
        } else {
            topViewController = keyWindow?.rootViewController
        }
        while true {
            if let presented = topViewController?.presentedViewController {
                topViewController = presented
            } else if let navController = topViewController as? UINavigationController {
                topViewController = navController.topViewController
            } else if let tabBarController = topViewController as? UITabBarController {
                topViewController = tabBarController.selectedViewController
            } else {
                // Handle any other third party container in `else if` if required
                break
            }
        }
        return topViewController
    }
  
}

class ViewController: UIViewController, AdaptyPaywallControllerDelegate {
        
        public func paywallController(
            _ controller: AdaptyPaywallController,
            didPerform action: AdaptyUI.Action
        ) {
            switch action {
            case .close:
                controller.dismiss(animated: true)
            case let .openURL(url):
                UIApplication.shared.open(url, options: [:])
            case .custom:
                break
            @unknown default:
                break
            }
        }


    /// If product was selected for purchase (by user or by system), this method will be invoked.
    ///
    /// - Parameters:
    ///     - controller: an ``AdaptyPaywallController`` within which the event occurred.
    ///     - product: an ``AdaptyPaywallProduct`` which was selected.
    public func paywallController(
        _ controller: AdaptyPaywallController,
        didSelectProduct product: AdaptyPaywallProductWithoutDeterminingOffer
    )
    {}

    /// If user initiates the purchase process, this method will be invoked.
    ///
    /// - Parameters:
    ///     - controller: an ``AdaptyPaywallController`` within which the event occurred.
    ///     - product: an ``AdaptyPaywallProduct`` of the purchase.
    public func paywallController(
        _ controller: AdaptyPaywallController,
        didStartPurchase product: AdaptyPaywallProduct
    )
    {}

    /// This method is invoked when a successful purchase is made.
    ///
    /// The default implementation is simply dismissing the controller:
    /// ```
    /// controller.dismiss(animated: true)
    /// ```
    /// - Parameters:
    ///   - controller: an ``AdaptyPaywallController`` within which the event occurred.
    ///   - product: an ``AdaptyPaywallProduct`` of the purchase.
    ///   - purchaseResult: an ``AdaptyPurchaseResult`` object containing up to date information about successful purchase.
    public func paywallController(
        _ controller: AdaptyPaywallController,
        didFinishPurchase product: AdaptyPaywallProduct,
        purchaseResult: AdaptyPurchaseResult
    ){}

    /// This method is invoked when the purchase process fails.
    /// - Parameters:
    ///   - controller: an ``AdaptyPaywallController`` within which the event occurred.
    ///   - product: an ``AdaptyPaywallProduct`` of the purchase.
    ///   - error: an ``AdaptyError`` object representing the error.
    public func paywallController(
        _ controller: AdaptyPaywallController,
        didFailPurchase product: AdaptyPaywallProduct,
        error: AdaptyError
    )
    {}

    /// If user initiates the restore process, this method will be invoked.
    ///
    /// - Parameters:
    ///     - controller: an ``AdaptyPaywallController`` within which the event occurred.
    public func paywallControllerDidStartRestore(_ controller: AdaptyPaywallController) {}

    /// This method is invoked when a successful restore is made.
    ///
    /// Check if the ``AdaptyProfile`` object contains the desired access level, and if so, the controller can be dismissed.
    /// ```
    /// controller.dismiss(animated: true)
    /// ```
    ///
    /// - Parameters:
    ///   - controller: an ``AdaptyPaywallController`` within which the event occurred.
    ///   - profile: an ``AdaptyProfile`` object containing up to date information about the user.
    public func paywallController(
        _ controller: AdaptyPaywallController,
        didFinishRestoreWith profile: AdaptyProfile
    ){}

    /// This method is invoked when the restore process fails.
    /// - Parameters:
    ///   - controller: an ``AdaptyPaywallController`` within which the event occurred.
    ///   - error: an ``AdaptyError`` object representing the error.
    public func paywallController(
        _ controller: AdaptyPaywallController,
        didFailRestoreWith error: AdaptyError
    ){}

    /// This method will be invoked in case of errors during the screen rendering process.
    /// - Parameters:
    ///   - controller: an ``AdaptyPaywallController`` within which the event occurred.
    ///   - error: an ``AdaptyError`` object representing the error.
    public func paywallController(
        _ controller: AdaptyPaywallController,
        didFailRenderingWith error: AdaptyError
    ) {}

    /// This method is invoked in case of errors during the products loading process.
    /// - Parameters:
    ///   - controller: an ``AdaptyPaywallController`` within which the event occurred.
    ///   - error: an ``AdaptyError`` object representing the error.
    /// - Returns: Return `true`, if you want to retry products fetching.
    public func paywallController(
        _ controller: AdaptyPaywallController,
        didFailLoadingProductsWith error: AdaptyError
    ) -> Bool { return true}

    /// This method is invoked if there was a propblem with loading a subset of paywall's products.
    /// - Parameters:
    ///   - controller: an ``AdaptyPaywallController`` within which the event occurred.
    ///   - failedIds: an array with product ids which was failed to load.
    /// - Returns: Return `true`, if you want to retry products fetching.
    public func paywallController(
        _ controller: AdaptyPaywallController,
        didPartiallyLoadProducts failedIds: [String]
    ) {}
    
    override func loadView() {
        // super.loadView()   // DO NOT CALL SUPER
        
        view = UIView()
        view.backgroundColor = .lightGray
    }
}

