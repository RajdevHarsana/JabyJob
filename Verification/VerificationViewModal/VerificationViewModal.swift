//
//  VerificationViewModal.swift
//  JabyJob
//
//  Created by DMG swift on 18/01/22.
//

import Foundation
import UIKit
import TTGSnackbar

class VerificationViewModal{
    weak var VC: VerificationVC?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func userUpdatePassApi(){
        
        let dict = ["password":VC?.txtNewPass.text ?? "","password_confirmation":VC?.txtConfrimPass.text ?? "","user_id":VC?.userId ?? 0,"otp":VC?.txtOnePass.text ?? ""] as JsonDict
        
        
        ApiClass().updatedPassApi(view: (VC?.view)!, BaeUrl: baseUrl+"update-password", paramters: dict) { result in
            print(result)
            
            let data = result as? [String:Any]
            let snackbar = TTGSnackbar(message:  data?["message"] as? String ?? "", duration: .short)
            snackbar.show()
            if data?["status"] as? Int ?? 0 == 1 {
                self.appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
            }
        }
    }
    
    func setEmptyErroMsg() {
        
        VC?.txtOnePass.setError(nil, show: false)
        VC?.txtNewPass.setError(nil, show: false)
        VC?.txtConfrimPass.setError(nil, show: false)
        VC?.txtConfrimPass.setError(nil, show: false)
    }
    
    func resendOtp(){
        ApiClass().verifyotpApi(view: (VC?.view)!, BaeUrl: baseUrl+"resend_otp", paramters:["user_id":VC?.userId ?? 0]) { result in
            print(result)
            let data = result as? [String:Any]
            let snackbar = TTGSnackbar(message: data?["message"] as? String ?? "", duration: .short)
            snackbar.show()
            
        }
    }
    
    
    func validationsOnFields(){
        
        if VC?.txtOnePass.text! == "" {
            VC?.txtOnePass.setError("Please enter one time password !", show: false)
        }
        
        if VC?.txtNewPass.text! == "" {
            VC?.txtNewPass.setError("Please enter new password !", show: false)
            
        }
        
        if VC?.txtConfrimPass.text! == "" {
            VC?.txtConfrimPass.setError("Please enter confirm password !", show: false)
            
        }
        
        if VC?.txtNewPass.text! != VC?.txtConfrimPass.text {
            VC?.txtConfrimPass.setError("Passsword dose not match !", show: false)
            //            return
        }
        
        if VC?.txtOnePass.text ?? "" != "" &&  VC?.txtNewPass.text ?? "" != "" && VC?.txtConfrimPass.text ?? "" != ""{
            setEmptyErroMsg()
            self.userUpdatePassApi()
        }
        
        
    }
}
