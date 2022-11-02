//
//  LoginViewModal.swift
//  JabyJob
//
//  Created by DMG swift on 05/01/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import TTGSnackbar
import DTTextField
import SocketIO

class LoginViewModal {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    weak var VC : LoginVc?
    var userdata = [UserModal]()
    var userId = Int()
    
    func initailSetup(){
        VC?.btnOtpVerifiy.isHidden = false
        VC?.otpView.fontTextField = UIFont(name: "Montserrat-SemiBold", size: 14.0)!
        
        VC?.CornorMain_view.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 2.0, opacity: 0.35)
//        txtMobileNum.floatingDisplayStatus = .never
    
       
        VC?.btnOtpVerifiy.isUserInteractionEnabled = false
        VC?.btnOtpVerifiy.alpha = 0.5
       
        VC?.popupView.isHidden = true
        VC?.Txtotp1.textAlignment = .center
        VC?.Txtotp2.textAlignment = .center
        VC?.Txtotp3.textAlignment = .center
        VC?.Txtotp4.textAlignment = .center
        
        VC?.Txtotp1.text = ""
        VC?.Txtotp2.text = ""
        VC?.Txtotp3.text = ""
        VC?.Txtotp4.text = ""
        
        VC?.txtMobileNum.text = ""
        VC?.txtPassword.text = ""
    }
    
    func otpFieldsValidation(){
        if VC?.Txtotp1.text == "" {
            
            VC?.Txtotp1.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            VC?.Txtotp1.borderWidth = 1
           
            VC?.Txtotp2.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            VC?.Txtotp2.borderWidth = 1
            
            VC?.Txtotp3.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            VC?.Txtotp3.borderWidth = 1
            
            VC?.Txtotp4.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            VC?.Txtotp4.borderWidth = 1
            
        }
    }
    
    func loginUserApi() {
        let dict = ["phone":VC?.txtMobileNum.text ?? "",
                    "password":VC?.txtPassword.text ?? "","country_code":VC?.countryCode ?? 0] as JsonDict
        ApiClass().loginApi(view: (VC?.view)!, BaeUrl: baseUrl+"login", paramters: dict) { result in
            print(result)
//            self.userdata.append(result as! UserModal)
            let data = result as? [String:Any]
            
            let values =  data?["data"] as? [String:Any]
           
//            let message = data?["message"] as? [String:Any]
            if  values?["verified_status"] as? Int ?? 0 == 2 {
                self.userId = values?["id"] as? Int ?? 0
                self.VC?.startOtpTimer()
                self.VC?.btnResend.isUserInteractionEnabled = false
                self.VC?.popupView.isHidden = false
            }else {
               
                //print(array)
                if data?["status"] as? Int == 0 {
     
                        let snackbar = TTGSnackbar(message:  data?["message"] as? String ?? "", duration: .short)
                    snackbar.messageTextColor = .white
                        snackbar.show()
                }else {
                    UserDefaults.standard.set(1, forKey: "UserLogin")
                    UserDefaults.standard.set(data!, forKey: "userData")
                  let userData = data?["data"] as? [String:Any] ?? [:]
                    UserDefaults.standard.set(userData["role_id"] as? Int ?? 0, forKey: "role_id")
                    UserDefaults.standard.set(userData["id"] as? Int ?? 0, forKey: "user_id")
                    UserDefaultData.set(data?["token"] as? String ?? "", forKey: "userToken")
                   let value = UserDefaults.standard.value(forKey: "userData") as? [String:Any]
                    print(value)
                    UserDefaults.standard.synchronize()
 
                        let snackbar = TTGSnackbar(message: data?["message"] as? String ?? "", duration: .short)
                        snackbar.show()

                    self.appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
                }
       
            }
        }
    }
    
    func verifyOtpApi(){
        let otp = VC?.otpView.text
        
        let dict = ["user_id":self.userId,"otp":otp ?? 0] as [String : Any]
        ApiClass().verifyotpApi(view: (VC?.view)!, BaeUrl: baseUrl+"verify_account", paramters: dict) { result in
            print(result)
            let data = result as? [String:Any]
            if data?["status"] as? Int ?? 0 == 0{
                let snackbar = TTGSnackbar(message: data?["message"] as? String ?? "", duration: .short)
                snackbar.show()
                
            }else {
                UserDefaults.standard.removeObject(forKey:"UserLogin")
                UserDefaults.standard.set(1, forKey: "UserLogin")
                UserDefaults.standard.removeObject(forKey:"userData")
                UserDefaults.standard.set(data!, forKey: "userData")
                UserDefaults.standard.synchronize()
                
                UserDefaultData.set(data?["token"] as? String ?? "", forKey: "userToken")
                let snackbar = TTGSnackbar(message: data?["message"] as? String ?? "", duration: .short)
                snackbar.show()
                self.VC?.popupView.isHidden = true
                let storyboard = UIStoryboard(name: "Interest", bundle: nil)
                           let vc = storyboard.instantiateViewController(withIdentifier: "InterestSelectionVC")
                self.VC?.navigationController?.pushViewController(vc, animated: true)
            }
            

        }
    }
    
    
    func resendOtp(){
        ApiClass().verifyotpApi(view: (VC?.view)!, BaeUrl: baseUrl+"resend_otp", paramters:["user_id":self.userId]) { result in
            print(result)
            let data = result as? [String:Any]
            let snackbar = TTGSnackbar(message: data?["message"] as? String ?? "", duration: .short)
            snackbar.show()
            
        }
    }
}


