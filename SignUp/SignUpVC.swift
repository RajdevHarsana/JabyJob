//
//  SignUpVC.swift
//  JabyJob
//
//  Created by DMG swift on 06/01/22.
//

import UIKit
import CoreTelephony
import TTGSnackbar
import NVActivityIndicatorView
import DPOTPView
import GoogleSignIn
import Alamofire


///GetSocialSingupdataFromLoginProtocall
protocol SocialSignUp {
    func GetSocialSingupdata(fullName:String,userName:String,gamil:String,userId:String)
}

class SignUpVC: BaseViewController, countryPhoneCode, countryName,UITextFieldDelegate,MyTextFieldDelegate,SocialSignUp {
   
    
    func GetSocialSingupdata(fullName: String, userName: String, gamil gmail: String,userId:String) {
        
        self.TxtEmail.text = gmail
        self.TxtFullName.text = fullName
        self.TxtUserName.text = userName
        self.gmailUserId = userId
        self.isSocail = true
    }
    
    
    func textFieldDidDelete() {
            print("delete")
        }
   
    func multipalCountryName(countryNames: [[String : Any]]) {
        print(countryNames)
        btnLeading.constant = -260
        multipalCountry.removeAll()
        countryIds.removeAll()
        if countryNames.count == 0 {
            self.TxtCityName.text = ""
        }
        for i in 0..<countryNames.count{
            let countryName = countryNames[i]["name"] as? String ?? ""
            self.multipalCountry.append(countryName)
            self.countryIds.append(countryNames[i]["id"] as? Int ?? 0)
            self.TxtCityName.setError(nil, show: false)
        }
        
        
        if self.multipalCountry.count > 2 {
            self.TxtCityName.text = "\(self.multipalCountry.count) countries selected"
        }else {
            TxtCityName.text = multipalCountry.map{String($0)}.joined(separator: ",")
        }
        
    }
    
    func countryName(countryId: [String : Any]) {
        print(countryId)
//
        if countryType == 0 {
            self.countryIds.removeAll()
            txtCountryCode.text = "+ \(countryId["phonecode"] as? Int ?? 0)"
//            self.countryIds.append(countryId["id"] as? Int ?? 0)
            selectCountryId = countryId["id"] as? Int ?? 0
            print(self.countryIds)
        }else {
            self.countryIds.removeAll()
            TxtCityName.text = countryId["name"] as? String ?? ""
            self.countryIds.append(countryId["id"] as? Int ?? 0)
            print(self.countryIds)
        }
    }
    
    
    
    var indicatorView: NVActivityIndicatorView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var Fullname_View: UIView!
    @IBOutlet weak var Username_View: UIView!
    @IBOutlet weak var Mobile_View: UIView!
    @IBOutlet weak var City_View: UIView!
    @IBOutlet weak var Email_View: UIView!
    @IBOutlet weak var Password_View: UIView!
    @IBOutlet weak var ConfirmPassword_View: UIView!
    @IBOutlet weak var CornorMain_view: UIView!
    @IBOutlet weak var Btn_Next: UIButton!
    @IBOutlet weak var TxtFullName: UITextField!
    @IBOutlet weak var TxtUserName: UITextField!
    @IBOutlet weak var TxtMobileNo: UITextField!
    @IBOutlet weak var TxtCityName: UITextField!
    @IBOutlet weak var TxtEmail: UITextField!
    @IBOutlet weak var TxtPassword: UITextField!
    @IBOutlet weak var TxtConfirmPassword: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var Txtotp1: MyTextField!
    @IBOutlet weak var Txtotp2: MyTextField!
    @IBOutlet weak var Txtotp3: MyTextField!
    @IBOutlet weak var Txtotp4: MyTextField!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnCountryFlag: UIButton!
    @IBOutlet weak var btncountrySelect: UIButton!
    @IBOutlet weak var btnVerifiy: UIButton!
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var flagimg: UIImageView!
    @IBOutlet weak var lbltimer: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOtpTitle: UILabel!
    @IBOutlet weak var numLadingConst:NSLayoutConstraint!
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var btnOtpVerifiy:UIButton!
    @IBOutlet weak var btnLeading:NSLayoutConstraint!
    @IBOutlet weak var otpView:DPOTPView!
    var singnUpViewModal = SignUpViewModal()
    var countriesData = [(name: String, flag: String)]()
    let networkInformation = CTTelephonyNetworkInfo()
    var selectCountryId = Int()
    var countryType = 0
    var isFrom = Int()
    var isVerifiy = false
    var countryIds = [Int]()
    var multipalCountry = [String]()
    var dataOfName = [[String:Any]]()
    var timer: Timer?
    var totalTime = 30
    var txtfld = UITextField()
    var gmailUserId = String()
    private var isSocail = false
    private var userId = Int()
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
       {
           if TxtFullName.isFirstResponder {
               let validString = CharacterSet(charactersIn: "!@#$%^&*()+{}[]|\"<>,~`/:;?-=\\¥'£•¢")

               if (textField.textInputMode?.primaryLanguage == "emoji") || textField.textInputMode?.primaryLanguage == nil {
                   return false
               }
               if let range = string.rangeOfCharacter(from: validString)
               {
                   print(range)
                   
//                   TxtFullName.setError("Invalid input, whitespace and special characters are not allowed", show: false)
                   return false
               }
               
               
               if TxtFullName.text?.count ?? 0 == 120 {
                   TxtFullName.setError("Please input b/t 3 to 120 characters as Full Name", show: false)
                   return true
               }
           }
           if TxtUserName.isFirstResponder {
               let validString = CharacterSet(charactersIn: " !@#$%^&*()+{}[]|\"<>,~`/:;?=\\¥'£•¢")

               if (textField.textInputMode?.primaryLanguage == "emoji") || textField.textInputMode?.primaryLanguage == nil {
                   return false
               }
               if let range = string.rangeOfCharacter(from: validString)
               {
//                   TxtUserName.setError("Invalid input, Limited special characters are allowed", show: false)
                   print(range)
                   return false
               }
               
               if TxtUserName.text?.count ?? 0 == 120 {
                   TxtUserName.setError("Please input b/t 3 to 55 characters Invalid input", show: false)
                   return true
               }
               
           }
           
            if popupView.isHidden == true {
               
               textField.setError(nil, show: false)
           }else {
               if ((textField.text?.count)! < 1 ) && (string.count > 0)
               {
                if textField == Txtotp1
                {
                  Txtotp1.borderColor = UIColor(named: "warmGrey")
//                  flagimg.borderWidth = 1
                    
                 Txtotp2.becomeFirstResponder()
                }
                if textField == Txtotp2
                {
                    Txtotp2.borderColor = UIColor(named: "warmGrey")
                 Txtotp3.becomeFirstResponder()
                }
                if textField == Txtotp3
                {
                    Txtotp3.borderColor = UIColor(named: "warmGrey")
                 Txtotp4.becomeFirstResponder()
                 
                }
                if textField == Txtotp4
                {
                    Txtotp4.borderColor = UIColor(named: "warmGrey")
                 Txtotp4.resignFirstResponder()
                 
                }
                textField.text = string
                return false
               }
               else if ((textField.text?.count)! >= 1) && (string.count == 0)
               {
                if textField == Txtotp2
                {
                    if textField.text == ""{
                        Txtotp1.becomeFirstResponder()
                    }
                    Txtotp2.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
//                    Txtotp1.borderWidth = 1
                    
                    Txtotp1.becomeFirstResponder()
                 
                }
                if textField == Txtotp3
                {
                    Txtotp3.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                 Txtotp2.becomeFirstResponder()
                 
                }
                if textField == Txtotp4
                {
                    Txtotp4.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                 Txtotp3.becomeFirstResponder()
                 
                }
                if textField == Txtotp1
                {
                    Txtotp1.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                    Txtotp1.borderWidth = 1
                    Txtotp1.resignFirstResponder()
                }
                textField.text = ""
                return false
               }
               else if (textField.text?.count)! >= 1
               {
                textField.text = string
                return false
               }
           }
           
        
        return true
       }

     func startOtpTimer() {
               self.totalTime = 30
               self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
           }
       
       @objc func updateTimer() {
//               print(self.totalTime)
               self.lbltimer.text = self.timeFormatted(self.totalTime) // will show timer
               if totalTime != 0 {
                   totalTime -= 1  // decrease counter timer
               } else {
                   if let timer = self.timer {
                       self.lbltimer.isHidden = true
                       timer.invalidate()
                       btnResend.isUserInteractionEnabled = true
                       self.timer = nil
                   }
               }
           }
       func timeFormatted(_ totalSeconds: Int) -> String {
           let seconds: Int = totalSeconds % 60
           let minutes: Int = (totalSeconds / 60) % 60
           return String(format: "%02d:%02d", minutes, seconds)
       }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaultData.value(forKey: "user") as? Int == 3 {
            self.btnCountryCode.isUserInteractionEnabled = true
            self.btncountrySelect.isUserInteractionEnabled = true
            self.TxtCityName.isUserInteractionEnabled = true
            self.TxtCityName.placeholder = "Select Countries"
            self.lblTitle.text = "Overseas Job Applicant"
        }else {
            self.TxtCityName.isUserInteractionEnabled = true
            self.btnCountryCode.isUserInteractionEnabled = true
            self.btncountrySelect.isUserInteractionEnabled = true
            self.lblTitle.text = "JOB SEEKER"
        }
        
        self.Txtotp1.text = ""
        self.Txtotp2.text = ""
        self.Txtotp3.text = ""
        self.Txtotp4.text = ""
        
       
        self.TxtMobileNo.text = ""
        self.txtCountryCode.text = ""
        
        self.TxtCityName.text = ""
        self.TxtPassword.text = ""
        self.TxtConfirmPassword.text = ""
       
       if isSocail == false{
           self.TxtUserName.text = ""
           self.TxtFullName.text = ""
           self.TxtEmail.text = ""
        }
        
         /// 'initialize SingnUpViewModal'
         singnUpViewModal.VC = self
         otpView.dpOTPViewDelegate = self
         TxtMobileNo.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
         
         showAlert()
         
         /// 'Textfield delegate'
         TxtFullName.delegate = self
         TxtUserName.delegate = self
         TxtMobileNo.delegate = self
         TxtCityName.delegate = self
         TxtEmail.delegate = self
         TxtPassword.delegate = self
         TxtConfirmPassword.delegate = self
        singnUpViewModal.initialSetup()
         
         if UserDefaultData.value(forKey: "user") as? Int == 3 {
             self.txtCountryCode.placeholder = "+"
             self.lblTitle.text = "Overseas Job Applicant"
         }else {
//             self.countryIds.append(2)
//             self.txtCountryCode.text = "+880"
//             selectCountryId = 2
//             self.TxtCityName.text = "Bangladesh"
             self.lblTitle.text = "JOB SEEKER"
         }
        singnUpViewModal.initialSetup()
    }
    
    
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
        print("textField: \(TxtMobileNo.text!)")
        
//        if TxtMobileNo.text?.count ?? 0 == 7 {
//            numLadingConst.constant = 60
//            btnVerifiy.isHidden = false
//        }else {
//            numLadingConst.constant = 15
//            btnVerifiy.isHidden = true
//        }
        

//        if validatePassword(textField.text!) {
//            // correct password
//            button.isEnabled = true
//        } else {
//            button.isEnabled = false
//        }
    }

    let (blurView,activityIndicatorView) = Helper.getLoaderViews()
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
           return true
    }
    
     func textFieldDidBeginEditing(_ textField: UITextField){
        txtfld = textField
//        if (textField == TxtCityName) {
//            //this is textfield 2, so call your method here
////            view.endEditing(true)
//           textField.resignFirstResponder()
//
//        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField)
//        if textField == TxtMobileNo{
//            TxtMobileNo.resignFirstResponder()
//        }
        textField.resignFirstResponder()
    }
   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard text.isEmpty else { return true } // No backspace pressed
        if (range.upperBound > range.lowerBound) {
            print("Backspace pressed")
        } else if (range.upperBound == range.lowerBound) {
            print("Backspace pressed but no text to delete")
            if (textView.text.isEmpty) || (textView.text == nil) {
                print("Text view is empty")
            }
        }
        return true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//
//        if isFrom == 2 {
//
////            btnCountryCode.isUserInteractionEnabled = true
//            TxtCityName.isUserInteractionEnabled = false
//            btnCountryFlag.isUserInteractionEnabled = false
////            btnCountry
//        }else {
//            self.countryIds.append(19)
//            self.txtCountryCode.text = "+880"
//            selectCountryId = 19
//            self.TxtCityName.text = "Bangladesh"
////            btnCountryCode.isUserInteractionEnabled = false
//            TxtCityName.isUserInteractionEnabled = true
//            btnCountryFlag.isUserInteractionEnabled = true
//        }
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    @IBAction func didTapTermAndConditon(_ sender:UIButton){
        
       
        
    }
    
    @IBAction func didTapAggree(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
       
        if sender.isSelected {
            isVerifiy = true
            btnAgree.setImage(UIImage(named: "Checked-2"), for: .normal)
        }else {
            isVerifiy = false
            btnAgree.setImage(UIImage(named: "Checked-1"), for: .normal)
        }
    }
    

    
    // MARK: - Button Actions
    
    func countryCode(countryId: JsonDict) {
//        self.TxtCityName.text = countryId["name"] as? String ?? ""
//        self.btnCountryCode.setTitle("+ \(countryId["phonecode"] as? Int ?? 0)", for: .normal)
        self.countryIds.removeAll()
        if countryType == 0 {
            txtCountryCode.text = "+ \(countryId["phonecode"] as? Int ?? 0)"
            self.countryIds.append(countryId["id"] as? Int ?? 0)
            selectCountryId = countryId["id"] as? Int ?? 0
            TxtCityName.text = countryId["name"] as? String ?? ""
            print(self.countryIds)
        }else {
//            self.countryIds.removeAll()
            TxtCityName.text = countryId["name"] as? String ?? ""
            self.countryIds.append(countryId["id"] as? Int ?? 0)
            print(self.countryIds)
        }
        
        if TxtCityName.text != "" {
            TxtCityName.setError(nil, show: false)
        }
        
       
    }
    @IBAction func didtapGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: appDelegate.signInConfig, presenting: self) { user, error in
           guard error == nil else { return }
//       print(user)
//            user?.userID
//            Optional("117091012005481797808")
            self.gmailUserId = user?.userID ?? ""
//              let emailAddress = user?.profile?.email
//
//               let fullName = user?.profile?.name
//               let givenName = user?.profile?.givenName
//               let familyName = user?.profile?.familyName
//               let profilePicUrl = user?.profile?.imageURL(withDimension: 320)
//            print(emailAddress,fullName,givenName,familyName,familyName)
            let dict = ["login_type":"google","login_id":user!.userID!] as JsonDict
            ApiClass().socialLoginApi(view: self.view, inputUrl: baseUrl+"social-login", parameters: dict) { result in
                let dict = result as? JsonDict
               
                    
                    let data = result as? [String:Any]
                    
                    let values =  data?["data"] as? [String:Any]
                   
        //            let message = data?["message"] as? [String:Any]
                    if  values?["verified_status"] as? Int ?? 0 == 2 {
                        self.singnUpViewModal.userId = values?["id"] as? Int ?? 0
                        self.startOtpTimer()
                        self.btnResend.isUserInteractionEnabled = false
                        self.popupView.isHidden = false
                    }else {
                       
                        //print(array)
                        if data?["status"] as? Int == 0 {
             
                            self.TxtFullName.text = user?.profile?.name
                            self.TxtUserName.text = user?.profile?.givenName
                            self.TxtEmail.text = user?.profile?.email
                            
                                let snackbar = TTGSnackbar(message:  data?["message"] as? String ?? "", duration: .short)
                            snackbar.messageTextColor = .white
                                snackbar.show()
                        }else {
                            UserDefaults.standard.set(1, forKey: "UserLogin")
                            UserDefaults.standard.set(data!, forKey: "userData")
                            UserDefaults.standard.synchronize()
                            UserDefaultData.set(data?["token"] as? String ?? "", forKey: "userToken")
                           let value = UserDefaults.standard.value(forKey: "userData") as? [String:Any]
//                            print(value)
                            
                            DispatchQueue.main.async {
                                
                                let snackbar = TTGSnackbar(message: data?["message"] as? String ?? "", duration: .short)
                                snackbar.show()
                            }
                           
                            self.appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
                        }
               
                    }
                  
            }
        }
    }
    
    @IBAction func didTapSignUp(_sender:UIButton) {
        /// 'Textfield validations'
        singnUpViewModal.validatonOnFields()
        
    }
    @IBAction func didTapBack(_sender:UIButton) {
        TxtFullName.setError(nil, show: false)
        if UserDefaultData.value(forKey: "introJob") as? Bool == true || UserDefaultData.value(forKey: "introIntrJob") as? Bool == true {
//            isTapOnSideMenu = true
            appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "TabBarController")
        }else {
//            isTapOnSideMenu = true
           
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapVerifiy(_sender:UIButton){
        self.lbltimer.text = ""
        popupView.isHidden = false
        startOtpTimer()
        btnResend.isUserInteractionEnabled = false
    }
    @IBAction func didTapCloseVerifiy(_sender:UIButton){
//        self.lbltimer.isHidden = true
        timer?.invalidate()
//        btnResend.isUserInteractionEnabled = true
        self.timer = nil
        popupView.isHidden = true
    }
    @IBAction func didTapConfrimVerifiy(_sender:UIButton){
        
        if Txtotp1.text == "" && Txtotp2.text == "" && Txtotp3.text == "" && Txtotp4.text == ""{
            singnUpViewModal.otpFieldsValidation()
            
            if otpView.validate() == true {
                singnUpViewModal.verifyOtpApi()
            }
//            let snackbar = TTGSnackbar(message: "Please enter otp !", duration: .long)
//            snackbar.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
//            snackbar.show()
        }else {
            
//            btnVerifiy.isUserInteractionEnabled = false
//            btnVerifiy.setTitleColor(.green, for: .normal)
//            btnVerifiy.setTitle("Verifiyed", for: .normal)
//            numLadingConst.constant = 80
//            isVerifiy = true
            
//            popupView.isHidden = true
//            let storyboard = UIStoryboard(name: "Interest", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "InterestSelectionVC")
//           self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    @IBAction func didTapResend(_sender:UIButton){
        startOtpTimer()
        lbltimer.isHidden = false
        btnResend.isUserInteractionEnabled = false
        singnUpViewModal.resendOtp()
        
        
//        popupView.isHidden = true
    }
    @IBAction func didTaplogin(_sender:UIButton) {
//        TxtFullName.setError(nil, show: false)
        self.isSocail = false
        singnUpViewModal.setEmptyErroMsg()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVc") as! LoginVc
        vc.socailDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didTapCountryPicker(_sender:UIButton) {
        countryType = 0
        let storyboard = UIStoryboard(name: "Country", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CountryPickerVC") as! CountryPickerVC
        vc.delegateCountryCode = self
//        vc.delegageCountryName = self
        self.navigationController?.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func didTapCountryPickerFlag(_sender:UIButton) {
        self.view.endEditing(true)
        countryType = 1
        let storyboard = UIStoryboard(name: "Country", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CountryPickerVC") as! CountryPickerVC
        vc.delegageCountryName = self
        vc.delegateCountryCode = self
        vc.priviousSelectdData = self.countryIds
        if UserDefaultData.value(forKey: "user") as? Int == 2 {
            vc.isCountryName = false
        }else {
            vc.isCountryName = false
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)

    }
   
//    @objc func didTapNameCountryTxt(){
//
//        self.view.endEditing(true)
//
////        TxtCityName.endEditing(true)
//        TxtMobileNo.endEditing(true)
////        TxtCityName.allowsEditingTextAttributes = false
//
//        countryType = 1
//        let storyboard = UIStoryboard(name: "Country", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "CountryPickerVC") as! CountryPickerVC
//        vc.delegageCountryName = self
//        vc.delegateCountryCode = self
//        vc.priviousSelectdData = self.countryIds
//        if UserDefaultData.value(forKey: "user") as? Int == 2 {
//            vc.isCountryName = false
//        }else {
//            vc.isCountryName = true
//        }
//        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder),
//                    to: nil, from: nil, for: nil)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.txtfld.resignFirstResponder()
//            self.txtfld.endEditing(true)
//        }
//        self.navigationController?.present(vc, animated: true, completion: nil)
//    }
    
    
    
}

extension String {

    static func emojiFlag(for countryCode: String) -> String! {
        func isLowercaseASCIIScalar(_ scalar: Unicode.Scalar) -> Bool {
            return scalar.value >= 0x61 && scalar.value <= 0x7A
        }

        func regionalIndicatorSymbol(for scalar: Unicode.Scalar) -> Unicode.Scalar {
            precondition(isLowercaseASCIIScalar(scalar))

            // 0x1F1E6 marks the start of the Regional Indicator Symbol range and corresponds to 'A'
            // 0x61 marks the start of the lowercase ASCII alphabet: 'a'
            return Unicode.Scalar(scalar.value + (0x1F1E6 - 0x61))!
        }

        let lowercasedCode = countryCode.lowercased()
        guard lowercasedCode.count == 2 else { return nil }
        guard lowercasedCode.unicodeScalars.reduce(true, { accum, scalar in accum && isLowercaseASCIIScalar(scalar) }) else { return nil }

        let indicatorSymbols = lowercasedCode.unicodeScalars.map({ regionalIndicatorSymbol(for: $0) })
        return String(indicatorSymbols.map({ Character($0) }))
    }
}
extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
extension UITextField {
    /// simulates removing a character from 1 position behind the cursor and returns the result
    func backSpace() -> String {
        guard var text = text, // local text property, matching textField's text
              let selectedRange = selectedTextRange,
              !text.isEmpty
        else { return "" }
        
        let offset = offset(from: beginningOfDocument, to: selectedRange.start)
        
        let index = text.index(text.startIndex, offsetBy: offset-1)
        // this doesn't remove text from the textField, just the local text property
        text.remove(at: index)
        return text
    }
}


protocol MyTextFieldDelegate: AnyObject {
    func textFieldDidDelete()
}

class MyTextField: UITextField {

    weak var myDelegate: MyTextFieldDelegate?

    override func deleteBackward() {
        super.deleteBackward()
        myDelegate?.textFieldDidDelete()
    }

}
extension SignUpVC : DPOTPViewDelegate {
   func dpOTPViewAddText(_ text: String, at position: Int) {
        print("addText:- " + text + " at:- \(position)" )
       if text.count < 4 {
           btnOtpVerifiy.isUserInteractionEnabled = false
           btnOtpVerifiy.alpha = 0.5
//           btnOtpVerifiy.isHidden = true
       }else {
           btnOtpVerifiy.isUserInteractionEnabled = true
           btnOtpVerifiy.alpha = 1
//           btnOtpVerifiy.isHidden = false
//           otpView.resignFirstResponder()
       }
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        print("removeText:- " + text + " at:- \(position)" )
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
        print("atDinesh:-\(position)")
    }
    func dpOTPViewBecomeFirstResponder() {
        print("atDinesh:-")
    }
    func dpOTPViewResignFirstResponder() {
        print("atDinesh:-")
    }
}
