//
//  LoginVc.swift
//  JabyJob
//
//  Created by DMG swift on 04/01/22.
//

import UIKit
import RxSwift
import RxCocoa
import TTGSnackbar
import DTTextField
import DPOTPView
import GoogleSignIn

class LoginVc: BaseViewController, UITextFieldDelegate,countryPhoneCode {
    func countryCode(countryId: [String : Any]) {
        print(countryId)
        let dict = countryId
        countryCode = dict["phonecode"] as? Int ?? 0
        self.btnCountryCode.setTitle("+ \(countryCode)", for: .normal)
    }
  
    
    func multipalCountryName(countryNames: [[String : Any]]) {
       
//        countryNames.compactMap { list in
//            self.countryData.append(list["id"] as? Int ?? 0)
//            self.countryName.append(list["name"] as? String ?? "")
//        }
    }
    
    
    
    @IBOutlet weak var txtMobileNum: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var CornorMain_view: UIView!
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var Txtotp1: UITextField!
    @IBOutlet weak var Txtotp2: UITextField!
    @IBOutlet weak var Txtotp3: UITextField!
    @IBOutlet weak var Txtotp4: UITextField!
    @IBOutlet weak var lbltimer: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var otpView:DPOTPView!
    @IBOutlet weak var btnOtpVerifiy:UIButton!
    @IBOutlet weak var btnCountryCode:UIButton!
    var socailDelegate:SocialSignUp? = nil
    var timer: Timer?
    var totalTime = 30
    var loginModelView = LoginViewModal()
    var disposeBag = DisposeBag()
    var countryCode = Int()
    override func viewDidLoad() {
       
        super.viewDidLoad()
        loginModelView.VC = self
        
//        self.txtMobileNum.setupLeftImage(imageName: "phone-call")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showAlert()
        otpView.dpOTPViewDelegate = self
        txtMobileNum.delegate = self
        txtPassword.delegate = self
        Txtotp1.delegate = self
        Txtotp2.delegate = self
        Txtotp3.delegate = self
        Txtotp4.delegate = self
        loginModelView.initailSetup()
    }
    
    @IBAction func didTapCounty(_sender:UIButton){
        let storyboard = UIStoryboard(name: "Country", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CountryPickerVC") as! CountryPickerVC
        vc.delegateCountryCode = self
//        vc.delegageCountryName = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
           return true
    }
    @objc(textField:shouldChangeCharactersInRange:replacementString:) func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
       {
           if textField == txtMobileNum || textField == txtPassword {
                       textField.setError(nil, show: false)
                       return true
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
    
    func setEmptyErroMsg() {
        
        txtMobileNum.setError(nil, show: false)
        txtPassword.setError(nil, show: false)
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
    
    @IBAction func didTapCloseVerifiy(_sender:UIButton){
//        self.lbltimer.isHidden = true
        timer?.invalidate()
//        btnResend.isUserInteractionEnabled = true
        self.timer = nil
        popupView.isHidden = true
    }
    
    @IBAction func didTapResend(_sender:UIButton){
        startOtpTimer()
        lbltimer.isHidden = false
        btnResend.isUserInteractionEnabled = false
        loginModelView.resendOtp()
        
    }
    @IBAction func didTapConfrimVerifiy(_sender:UIButton){
        
        if otpView.validate() == true{
            loginModelView.verifyOtpApi()
            
            
//            let snackbar = TTGSnackbar(message: "Please enter otp !", duration: .long)
//            snackbar.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
//            snackbar.show()
        }else {
//            btnVerifiy.isUserInteractionEnabled = false
//            btnVerifiy.setTitleColor(.green, for: .normal)
//            btnVerifiy.setTitle("Verifiyed", for: .normal)
//            numLadingConst.constant = 80
//            isVerifiy = true
            
            popupView.isHidden = true
            let storyboard = UIStoryboard(name: "Interest", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InterestSelectionVC")
           self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    // MARK: - Navigation
    @IBAction func didtapLogin(_ sender: UIButton) {
        
        if countryCode == 0 {
            let snackbar = TTGSnackbar(message:"Please select country code.", duration: .short)
        snackbar.messageTextColor = .white
            snackbar.show()
            
        }
        
        
       if txtMobileNum.text! == "" {
           txtMobileNum.setError("Please enter mobile number !", show: false)

        }
         if txtPassword.text! == ""
        {
            txtPassword.setError("Please enter Password !", show: false)
        }
       
//        if txtMobileNum.text?.count ?? 0 < 7
//        {
//            txtMobileNum.setError("Please enter valid mobile number !", show: false)
//
//        }
//        if txtPassword.text?.count ?? 0 < 6
//        {
//            txtPassword.setError("Password should  be min 6 characters !", show: false)
//        }
        
        if txtMobileNum.text! != "" && txtPassword.text! != "" && countryCode != 0 {
            setEmptyErroMsg()
            loginModelView.loginUserApi()
        }
        
  
        
    }
    @IBAction func didTapForgot(_ sender: Any) {
        txtPassword.setError(nil, show: false)
        txtMobileNum.setError(nil, show: false)
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapRegister(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC")
        txtMobileNum.setError(nil, show: false)
        txtPassword.setError(nil, show: false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didtapGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: appDelegate.signInConfig, presenting: self) { user, error in
           guard error == nil else { return }
//       print(user)
//            user?.userID
//            Optional("117091012005481797808")
//              let emailAddress = user?.profile?.email
//
//               let fullName = user?.profile?.name
//               let givenName = user?.profile?.givenName
//               let familyName = user?.profile?.familyName
//               let profilePicUrl = user?.profile?.imageURL(withDimension: 320)
//            print(emailAddress,fullName,givenName,familyName,familyName)
            
           // If sign in succeeded, display the app's main content View.
            
            let dict = ["login_type":"google","login_id":user!.userID!] as JsonDict
            ApiClass().socialLoginApi(view: self.view, inputUrl: baseUrl+"social-login", parameters: dict) { result in
                let dict = result as? JsonDict
               
                    
                    let data = result as? [String:Any]
                    
                    let values =  data?["data"] as? [String:Any]
                   
        //            let message = data?["message"] as? [String:Any]
                    if  values?["verified_status"] as? Int ?? 0 == 2 {
                        self.loginModelView.userId = values?["id"] as? Int ?? 0
                        self.startOtpTimer()
                        self.btnResend.isUserInteractionEnabled = false
                        self.popupView.isHidden = false
                    }else {
                       
                        //print(array)
                        if data?["status"] as? Int == 0 {
                            self.socailDelegate?.GetSocialSingupdata(fullName: user?.profile?.name ?? "", userName: user?.profile?.givenName ?? "", gamil: user?.profile?.email ?? "", userId: user!.userID!)

                                let snackbar = TTGSnackbar(message:  data?["message"] as? String ?? "", duration: .short)
                            snackbar.messageTextColor = .white
                                snackbar.show()
                            self.navigationController?.popViewController(animated: true)
                        }else {
                            UserDefaults.standard.set(1, forKey: "UserLogin")
                            UserDefaults.standard.set(data!, forKey: "userData")
                            UserDefaults.standard.synchronize()
                            UserDefaultData.set(data?["token"] as? String ?? "", forKey: "userToken")
                           let value = UserDefaults.standard.value(forKey: "userData") as? [String:Any]
                            print(value)
                            
                            DispatchQueue.main.async {
                                
                                let snackbar = TTGSnackbar(message: data?["message"] as? String ?? "", duration: .short)
                                snackbar.show()
                            }
                           
                            self.appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
                        }
               
                    }
                    
                    
                    
                    
//                }else {
            }
            
            
            
         }
    }
    @IBAction func didTapFacebook(_ sender: Any) {
    }
    @IBAction func didtapApple(_ sender: Any) {
    }
    
}

// Validation textFields
//extension LoginVc: UITextFieldDelegate {
//    // Remove error message after start editing
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        textField.setError(nil, show: false)
//        return true
//    }
//}



extension LoginVc : DPOTPViewDelegate {
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
