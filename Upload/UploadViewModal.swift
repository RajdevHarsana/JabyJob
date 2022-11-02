//
//  UploadViewModal.swift
//  JabyJob
//
//  Created by DMG swift on 19/01/22.
//

import Foundation
import UIKit

class UploadViewModal {
    
    weak var VC: UploadVC?
    
   
    
    func initialUIsetUp(){
        
       
//        VC?.subscriptionPopUPView.clipsToBounds = true
//        VC?.subscriptionPopUPView.layer.cornerRadius = 10
//        VC?.subscriptionPopUPView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        VC?.PlanPopUpView.clipsToBounds = true
        VC?.PlanPopUpView.layer.cornerRadius = 20
        VC?.PlanPopUpView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        VC?.BtnGoToHome.clipsToBounds = true
        VC?.BtnGoToHome.layer.cornerRadius = 50
        VC?.BtnGoToHome.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
//        VC?.BtnGoToHome.clipsToBounds = true
        VC?.subscriptionPopUPView.layer.cornerRadius = 20
        VC?.subscriptionPopUPView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        VC?.PopUp_View.roundCorners([.topRight, .topLeft], radius: 20)
        VC?.Btn_Gotohome.roundCorners([.topRight, .topLeft], radius: 50)
//        VC?.BtnGoToHome.roundCorners([.topRight, .topLeft], radius: 50)
        VC?.subscriptionPopUPView.isHidden = true
        VC?.ViewUploadVideo.isHidden = true
        VC?.ViewUploadResume.isHidden = true
        VC?.videoDocView.isHidden = true
        VC?.PopUp_View.isHidden = true
        VC?.UploadVideo_View.layer.cornerRadius = 10
        VC?.Upload_Resume_View.layer.cornerRadius = 10
        VC?.PopUpMain_View.isHidden = true
        VC?.PlanPopUpView.isHidden = true
        VC?.UploadVideo_View.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 4.0, opacity: 0.50)
        VC?.videoDocView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 4.0, opacity: 0.50)
        VC?.Upload_Resume_View.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 4.0, opacity: 0.50)
        // Do any additional setup after loading the view.
        VC?.Btn_Gotohome.roundCorner([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 30.0, borderColor: UIColor.clear, borderWidth: 0)
        VC?.PopUp_View.roundCorner([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 10.0, borderColor: UIColor.clear, borderWidth: 0)
        VC?.videoDocView.roundCorner([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 10.0, borderColor: UIColor.clear, borderWidth: 0)
        VC?.BtnPlan.roundCorner([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 30.0, borderColor: UIColor.clear, borderWidth: 0)
//        VC?.PopUpMain_View.isHidden = false
//        VC?.PlanPopUpView.isHidden = false
    }
    
}
