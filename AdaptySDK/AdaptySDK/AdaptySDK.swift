import Foundation
import UIKit

internal import Adapty
internal import AdaptyUI

@objc
public enum AdLogLevel: Int {
    case error
    /// `.error` +  messages from the SDK that do not cause critical errors, but are worth paying attention to
    case warn
    /// `.warn` +  information messages, such as those that log the lifecycle of various modules
    case info
    /// `.info` + any additional information that may be useful during debugging, such as function calls, API queries, etc.
    case verbose
    /// Debug purposes logging level
    case debug    }



@objc
public enum AdModalPresentStyle: Int {
   
        case fullScreen = 0
      
        case pageSheet = 1
       
        case formSheet = 2
      
        case currentContext = 3
      
        case custom = 4
      
        case overFullScreen = 5
      
        case overCurrentContext = 6
      
        case popover = 7
      
        case none = -1
       
        case automatic = -2
    }
    
    
@objc(AdaptySDK)
@MainActor
public class AdaptySDK : NSObject {
    //@objc
    //private var shared : AdaptySDK;
      
    static var vcontroller : ViewController = ViewController();
    
    @objc
    public override init() {
    }
    
    @objc
    public static func Activate(apiKey: String)  {
        Adapty.activate(apiKey)
    }
    
    @objc
    public static func Activate(apiKey: String, _observerMode : Bool, _logLevel : Int)  {
               
        Adapty.activate(with: AdaptyConfiguration
            .builder(withAPIKey: apiKey)
            .with(observerMode: _observerMode)
            .with(loglevel: AdaptyLog.Level(rawValue: _logLevel) ?? AdaptyLog.Level.debug)
                        //.with(customerUserId: "YOUR_USER_ID")
            .with(idfaCollectionDisabled: false)
            .with(ipAddressCollectionDisabled: false)) { error in
           }
        AdaptyUI.activate()
    }
    
    @objc
    public static func HasAnySubcriptions() async -> Bool {
        
        do {
            let profile = try await Adapty.getProfile()
            return  profile.subscriptions.count > 0 &&
                     profile.subscriptions.count(where: { ($1.isActive || $1.isInGracePeriod) }) > 0
        }catch {
            return false;
        }
    }
    
    //for testing
    /*
    @objc
    public static func GetPaywall(placementId: String) async -> AdPaywall? {
        
        do {
            let paywall = try await Adapty.getPaywall(placementId: placementId);
            return paywall.toAdPaywall();
        }catch {}
        
        return nil;
    }
    */

    @objc
    @MainActor
    public static func DisplayPaywall(placementId: String  ) async {
             
        let topController = UIApplication.shared.topViewController()

        do {
            
            let paywall = try await Adapty.getPaywall(placementId: placementId);
            
            let paywallConfiguration = try await AdaptyUI.getPaywallConfiguration(
                forPaywall: paywall
                //products: products,
                //observerModeResolver: <AdaptyObserverModeResolver>, // only for Observer Mode
                //tagResolver: <AdaptyTagResolver>,
                //timerResolver: <AdaptyTimerResolver>
            )
            
            let visualPaywall = try AdaptyUI.paywallController(
                with: paywallConfiguration,
                delegate: vcontroller,
                showDebugOverlay: false
            )
            visualPaywall.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
        
            topController!.present(visualPaywall, animated: true)
        }
        catch {}
         
    }
    
    @objc
    @MainActor
    public static func DisplayPaywallWithStyle(placementId: String, presentationStyle: AdModalPresentStyle ) async {
             
        let topController = UIApplication.shared.topViewController()

        do {
            
            let paywall = try await Adapty.getPaywall(placementId: placementId);
            
            let paywallConfiguration = try await AdaptyUI.getPaywallConfiguration(
                forPaywall: paywall
                //products: products,
                //observerModeResolver: <AdaptyObserverModeResolver>, // only for Observer Mode
                //tagResolver: <AdaptyTagResolver>,
                //timerResolver: <AdaptyTimerResolver>
            )
            
            let visualPaywall = try AdaptyUI.paywallController(
                with: paywallConfiguration,
                delegate: vcontroller,
                showDebugOverlay: false
            )

            visualPaywall.modalPresentationStyle =  UIModalPresentationStyle(rawValue: presentationStyle.rawValue) ?? UIModalPresentationStyle.fullScreen
            topController!.present(visualPaywall, animated: true)
        }
        catch {}
         
    }
 }

   
