//
//  SignUpViewModal.swift
//  JabyJob
//
//

import Foundation
import UIKit
import TTGSnackbar


class SignUpViewModal {
    weak var VC : SignUpVC?
    var userdata = [UserModal]()
    var userId = Int()
    func countryApi(){
        
        VC?.indicatorView.startAnimating()
    }
    //roll_id JobSeeker:- 2, InternationlJobSeeker:- 3
    
    
    func initialSetup(){
        VC?.otpView.fontTextField = UIFont(name: "Montserrat-SemiBold", size: 14.0)!
        VC?.btnOtpVerifiy.isHidden = true

        VC?.popupView.isHidden = true
        VC?.btnOtpVerifiy.isHidden = false
        VC?.btnOtpVerifiy.isUserInteractionEnabled = false
        VC?.btnOtpVerifiy.alpha = 0.5
        VC?.numLadingConst.constant = 16
        VC?.innerView.clipsToBounds = true
        VC?.innerView.layer.cornerRadius = 10
        VC?.innerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        VC?.bottomView.clipsToBounds = true
        VC?.bottomView.layer.cornerRadius = 30
        VC?.bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        /// 'View Shadow'
        VC?.CornorMain_view.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
        
    }
    
    
    func userRegisterApi(){
        let deviceToken =  UserDefaults.standard.value(forKey: "FCMToken") as? String ?? ""
        
       var userRole = 0
        if UserDefaultData.value(forKey: "user") as? Int == 2 {
            userRole = UserDefaultData.value(forKey: "user") as? Int ?? 0
        }else {
            userRole = UserDefaultData.value(forKey: "user") as? Int ?? 0
        }
        
        let dict = ["role_id":userRole,"phone":VC?.TxtMobileNo.text ?? "","country_id":VC?.selectCountryId ?? 0,"full_name":VC?.TxtFullName.text ?? "","username":VC?.TxtUserName.text ?? "","password":VC?.TxtPassword.text ?? "","password_confirmation":VC?.TxtConfirmPassword.text ?? "","country":VC?.countryIds ?? 0,"email":VC?.TxtEmail.text ?? "","device_type":2,"device_token":deviceToken,"google_id":VC?.gmailUserId ?? ""] as JsonDict
    
        ApiClass().registerApi(view: (VC?.view!)!, BaeUrl: baseUrl+"register", paramters: dict) { result in
            print(result)
            let dict = result as? JsonDict
            let data = dict?["data"] as? JsonDict
//            self.userdata.append(result as! UserModal)
      
            if data?["verified_status"] as? Int ?? 0 == 2 {
                self.userId = data?["id"] as? Int ?? 0
                
               
              //  UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
                let mobileNumer = "\(self.VC?.txtCountryCode.text ?? "") " + (self.VC?.TxtMobileNo.text)!
//                self.VC?.lblOtpTitle.text = "\(self.VC?.TxtEmail.text ?? "")"
                self.VC?.popupView.isHidden = false
                self.VC?.lblOtpTitle.text = self.VC?.TxtEmail.text
                self.VC?.btnResend.isUserInteractionEnabled = false
                self.VC?.startOtpTimer()

        }
            
        }
    
    }
    
    
    func verifyOtpApi(){
        var otp = VC?.otpView.text ?? ""
       
        let dict = ["user_id":self.userId,"otp":otp] as [String : Any]
        ApiClass().verifyotpApi(view: (VC?.view)!, BaeUrl: baseUrl+"verify_account", paramters: dict) { result in
            print(result)
            let data = result as? [String:Any]
            if data?["status"] as? Int ?? 0 == 0{
                let snackbar = TTGSnackbar(message: data?["message"] as? String ?? "", duration: .short)
                snackbar.show()
            }else {
               let userData = data?["data"] as? JsonDict
                let snackbar = TTGSnackbar(message: data?["message"] as? String ?? "", duration: .short)
                snackbar.show()
                UserDefaultData.set(data?["token"] as? String ?? "", forKey: "userToken")
                if userData?["role_id"] as? Int ?? 0 != 2{
                    showingPopUp = true
                }
//                UserDefaults.standard.setValue(userData?["id"] as? Int ?? 0, forKey: "user_id")
                
                UserDefaults.standard.set(userData?["id"] as? Int ?? 0, forKey: "userid")
                
                UserDefaults.standard.set(1, forKey: "UserLogin")
                UserDefaults.standard.set(data!, forKey: "userData")
                UserDefaults.standard.synchronize()
                
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
    
    
    func setEmptyErroMsg() {
        VC?.TxtPassword.setError(nil, show: false)
        VC?.TxtFullName.setError(nil, show: false)
        VC?.TxtUserName.setError(nil, show: false)
        VC?.TxtMobileNo.setError(nil, show: false)
        VC?.TxtCityName.setError(nil, show: false)
        VC?.TxtEmail.setError(nil, show: false)
        VC?.TxtConfirmPassword.setError(nil, show: false)
    }
    
    
    func validatonOnFields() {
        VC?.btnLeading.constant = -260
        if VC?.TxtFullName.text! == "" || VC?.TxtFullName.text?.count ?? 0 < 3 {
            VC?.TxtFullName.setError("Please input minimum 3 characters as Full Name !", show: false)
        }
       
        if VC?.TxtUserName.text! == "" || VC?.TxtUserName.text?.count ?? 0 < 3
        {
            VC?.TxtUserName.setError(" Please input minimum 3 characters !", show: false)
           
        }
       
        if VC?.TxtMobileNo.text! == ""
        {
            VC?.TxtMobileNo.setError("Please enter MobileNo !", show: false)
            
        }
        if VC?.TxtMobileNo.text?.count ?? 0 < 7
        {
            VC?.TxtMobileNo.setError("Please enter valid mobile number !", show: false)
            
        }
        
        if VC?.TxtCityName.text! == ""
        {
            VC?.TxtCityName.setError("Please select country !", show: false)
            VC?.btnLeading.constant = -240
           
        }
        
        
        if VC?.TxtEmail.text! == ""
        {
            VC?.TxtEmail.setError("Please enter email !", show: false)
           
        }
        else {
            VC?.TxtEmail.setError(nil, show: false)
        }
        if VC?.TxtEmail.text?.isValidEmail == false{
            VC?.TxtEmail.setError("Please enter valid email address !", show: false)
            return
        }
        if VC?.TxtPassword.text! == ""
        {
            VC?.TxtPassword.setError("Please enter Password !", show: false)
        }
        
        if VC?.TxtConfirmPassword.text! == ""
        {
            VC?.TxtConfirmPassword.setError("Please enter confirmPassword !", show: false)
            
        }
        if VC?.TxtPassword.text?.count ?? 0 < 6
        {
            VC?.TxtPassword.setError("Password should  be min 6 characters !", show: false)
        }
        if VC?.TxtConfirmPassword.text?.count ?? 0 < 6
        {
            VC?.TxtConfirmPassword.setError("Confirm password should  be min 6 characters !", show: false)
        }
        
        if VC?.TxtConfirmPassword.text?.count ?? 0 == 50 {
            VC?.TxtConfirmPassword.setError("Confirm password should  be max 50 characters !", show: false)
        }
            
            
        if VC?.TxtPassword.text?.count ?? 0 == 50 {
            VC?.TxtPassword.setError("Confirm password should  be max 6 TxtConfirmPassword !", show: false)
        }
        
        
        if VC?.TxtPassword.text! != VC?.TxtConfirmPassword.text { 
            VC?.TxtConfirmPassword.setError("Passsword dose not match !", show: false)
           return
        }
        
        if VC?.txtCountryCode.text ?? "" == "" {
            let snackbar = TTGSnackbar(message: "Please select country code !", duration: .short)
            snackbar.show()
        }
        
        if VC?.TxtFullName.text != "" && VC?.TxtUserName.text != "" && VC?.TxtMobileNo.text != "" && VC?.TxtCityName.text != "" && VC?.TxtEmail.text != "" && VC?.TxtPassword.text != "" && VC?.TxtConfirmPassword.text != "" && VC?.txtCountryCode.text?.count != 0 && VC?.isVerifiy == false {
            let snackbar = TTGSnackbar(message: "Please accept terms and conditions !", duration: .short)
            snackbar.show()
        }
        
//        if VC?.isVerifiy == true {
        if VC?.TxtFullName.text != "" && VC?.TxtUserName.text != "" && VC?.TxtMobileNo.text != "" && VC?.TxtCityName.text != "" && VC?.TxtEmail.text != "" && VC?.TxtPassword.text != "" && VC?.TxtConfirmPassword.text != "" && VC?.isVerifiy == true && VC?.txtCountryCode.text != "" {
            VC?.TxtPassword.setError(nil, show: false)
                userRegisterApi()
//            }
        }else {
            print("here")
//            if VC?.TxtMobileNo.text != "" {
//
//                    let snackbar = TTGSnackbar(message: "Please verifiy mobile number !", duration: .short)
//                    snackbar.show()
//                VC?.numLadingConst.constant = 60
//                VC?.btnVerifiy.isHidden = false
//            }
        }
        
        
        
        
       
    }
    
}
extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}
//extension UserDefaults {
//        func set<T: Encodable>(encodable: T, forKey key: String) {
//            if let data = try? JSONEncoder().encode(encodable) {
//                set(data, forKey: key)
//            }
//        }
//
//        func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
//            if let data = object(forKey: key) as? Data,
//                let value = try? JSONDecoder().decode(type, from: data) {
//                return value
//            }
//            return nil
//        }
//    }
extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}
