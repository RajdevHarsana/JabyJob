//
//  FortgotPassViewModal.swift
//  JabyJob
//
//  Created by DMG swift on 18/01/22.
//

import Foundation
import UIKit
import TTGSnackbar

class FortgotPassViewModal {
    weak var VC: ForgotPasswordVC?
    
    
    func userForgotPass() {
        let dict = ["email":VC?.txtMobileNum.text ?? "",]
        ApiClass().forgotPassApi(view: (VC?.view)!, BaeUrl: baseUrl+"forgot-password", paramters: dict) { result in
            print(result)
            let dataForgotPass = result as? [String:Any]
            let messages = dataForgotPass?["message"] as? [String:Any]
            let showdata = messages?["phone"] as? NSArray
            let userData = dataForgotPass?["data"] as? [String:Any]
            let snakbarMessages = showdata?[0] as? String ?? ""
            if dataForgotPass?["status"] as? Int ?? 0 == 1 {
                let snackbar = TTGSnackbar(message:  dataForgotPass?["message"] as? String ?? "", duration: .short)
//                snackbar.backgroundColor = .red
                snackbar.show()
            }else {
                let snackbar = TTGSnackbar(message:  dataForgotPass?["message"] as? String ?? "", duration: .short)
                
//                snackbar.backgroundColor = .green
                snackbar.show()
            }
          
            
            if dataForgotPass?["status"] as? Bool == true {
                let storyboard = UIStoryboard(name: "Verification", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                vc.userId = userData?["id"] as? Int ?? 0
                self.VC?.self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    
    
    
    
    func setEmptyErroMsg() {
        
        VC?.txtMobileNum.setError(nil, show: false)
    }
    func validateField() {
//        if VC?.txtMobileNum.text! == "" {
//            VC?.txtMobileNum.setError("Please enter mobile number !", show: false)
//            return
//        }
//
        if VC?.txtMobileNum.text ?? "" != "" {
            setEmptyErroMsg()
            userForgotPass()
        }
    }
}
