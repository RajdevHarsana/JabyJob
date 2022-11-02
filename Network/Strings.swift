//
//  String.swift
//  BleekSalon
//
//  Created by Ankur on 15/11/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

let baseUrl = "http://3.143.123.23/api/"
let videobaseurl = "https://jabyjobs.s3.us-east-2.amazonaws.com/public/uploads/video/"
let thumbnailbaseUrl = "http://3.143.123.23/public/uploads/video_thumbnail/"
let chatImageBaseUrl = "http://3.143.123.23/public/uploads/users/"
typealias JsonDict = [String:Any]

public class LoadingOverlay{

    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var bgView = UIView()

    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }

    public func showOverlay(view: UIView) {

        bgView.frame = view.frame
        bgView.backgroundColor = UIColor.gray
        bgView.addSubview(overlayView)
        bgView.autoresizingMask = [.flexibleLeftMargin,.flexibleTopMargin,.flexibleRightMargin,.flexibleBottomMargin,.flexibleHeight, .flexibleWidth]
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        overlayView.center = view.center
        overlayView.autoresizingMask = [.flexibleLeftMargin,.flexibleTopMargin,.flexibleRightMargin,.flexibleBottomMargin]
        overlayView.backgroundColor = UIColor.clear
       
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
       
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .gray
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
            overlayView.addSubview(activityIndicator)
        view.addSubview(bgView)
        self.activityIndicator.startAnimating()

    }

    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        bgView.removeFromSuperview()
    }
}


public func saveUserData(){
    
    
    
    
}

