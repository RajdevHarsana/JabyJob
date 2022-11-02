//
//  Reachability.swift
//  Reachability
//
//  Created by Leo Dabus on 2/9/19.
//  Copyright © 2019 Dabus.tv. All rights reserved.
//


    import Foundation
    import SystemConfiguration
    import UIKit
    import TTGSnackbar
    import NVActivityIndicatorView

func isInternetAvailable() -> Bool
   {
       var zeroAddress = sockaddr_in()
       zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
       zeroAddress.sin_family = sa_family_t(AF_INET)

       let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
           $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
               SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
           }
       }

       var flags = SCNetworkReachabilityFlags()
       if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
           return false
       }
       let isReachable = flags.contains(.reachable)
       let needsConnection = flags.contains(.connectionRequired)
       return (isReachable && !needsConnection)
   }

   func showAlert() {
       if !isInternetAvailable() {
           let snackbar = TTGSnackbar(message: "Internet is not available", duration: .long)
           snackbar.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
           snackbar.show()
//           let alert = UIAlertController(title: "Warning", message: "The Internet is not available", preferredStyle: .alert)
//           let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
//           alert.addAction(action)
//           present(alert, animated: true, completion: nil)
       }
   }


class Helper {
    static func getLoaderViews()->(UIView,NVActivityIndicatorView){
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 80, y: 80, width: 60, height:60), type: .ballTrianglePath, color: UIColor(named: "blueColor"))
        let blurView = UIView()
        // create your components,customise and return
        return (blurView,activityIndicatorView)
    }
}
extension NSObject{

    func addLoaderToView(view:UIView,blurView:UIView ,activityIndicatorView:NVActivityIndicatorView) {

                blurView.isHidden = false
                blurView.frame = view.frame
                blurView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)

                view.addSubview(blurView)
                view.isUserInteractionEnabled = false
                activityIndicatorView.center = blurView.center
                view.addSubview(activityIndicatorView)
                activityIndicatorView.startAnimating()
    }

    func removeLoader(activityIndicatorView:NVActivityIndicatorView,blurView:UIView,view:UIView)  {
        activityIndicatorView.stopAnimating()
        view.isUserInteractionEnabled = true
        blurView.isHidden = true
    }
}
