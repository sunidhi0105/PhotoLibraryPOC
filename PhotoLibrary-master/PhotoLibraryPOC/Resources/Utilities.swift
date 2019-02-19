//
//  Utilities.swift
//  PhotoLibraryPOC
//
//  Created by Sunidhi Gupta on 10/08/18.
//

import UIKit
import SystemConfiguration

class Utilities: NSObject {
    /**
     This function is used to show the alert in the given view controller
     
     - parameter title:      title of the alert
     - parameter message:    message of the alert
     - parameter controller: controller on which to show
     */
    class func showAlertWithTitle(_ title: String?, message: String?, controller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
    
    /**
     This function is used to check network is available or not
     - returns bool
     */
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
