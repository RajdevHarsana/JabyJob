//
//  Support.swift
//  JabyJob
//
//  Created by DMG swift on 24/01/22.
//

import UIKit
import TTGSnackbar
import MessageUI
class Support: BaseViewController,MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var desView: UIView!
    @IBOutlet weak var txtfullName:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtdes:TextViewWithPlaceholder!
    @IBOutlet weak var lblemail:UILabel!
    @IBOutlet weak var lblPhone:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameView.layer.shadowColor = #colorLiteral(red: 0.1215686275, green: 0.3294117647, blue: 0.7647058824, alpha: 0.15)
        nameView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        nameView.layer.shadowRadius = 25.0
        nameView.layer.shadowOpacity = 0.9
        emailView.layer.shadowColor = #colorLiteral(red: 0.1215686275, green: 0.3294117647, blue: 0.7647058824, alpha: 0.15)
        emailView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        emailView.layer.shadowRadius = 25.0
        emailView.layer.shadowOpacity = 0.9
        desView.layer.shadowColor = #colorLiteral(red: 0.1215686275, green: 0.3294117647, blue: 0.7647058824, alpha: 0.15)
        desView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        desView.layer.shadowRadius = 25.0
        desView.layer.shadowOpacity = 0.9
        getSupportDetail()
    }
    
    @IBAction func didTapMail(_sender:UIButton){
        self.sendMail()
    }
    @IBAction func BtndidTapBack(_ sender:UIButton) {
        self.dismiss(animated: true) {
            let objToBeSent = true
            NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: objToBeSent)
        }
//        self.navigationController?.popViewController(animated: false)
    }
    func getSupportDetail(){
        ApiClass().supportDetailApi(view: self.view, inputUrl: baseUrl+"support-detail", parameters: [:], header: self.userToken) { result in
            let dict = result as? [String:Any]
            if dict?["status"] as? Int ?? 0 == 1 {
                let data = dict?["data"] as? [String:Any]
                let supportDetail = data?["supportDetail"] as? [String:Any]
                self.lblemail.text = supportDetail?["email"] as? String ?? ""
                self.lblPhone.text = supportDetail?["phone"] as? String ?? ""
            }
        }
    }
    
    @IBAction func didtapSubmit(_ sender:UIButton){
        if txtfullName.text! == ""
        {
            let snackbar = TTGSnackbar(message:"Please enter full name !", duration: .short)
            snackbar.show()
            return
         }
          if txtEmail.text! == ""
         {
              let snackbar = TTGSnackbar(message:"Please email address !", duration: .short)
              snackbar.show()
              return
         }
        if txtEmail.text?.isValidEmail == false{
            let snackbar = TTGSnackbar(message:"Please enter valid email address !", duration: .short)
            snackbar.show()
            return
        }
        if txtdes.text! == ""
       {
            let snackbar = TTGSnackbar(message:"Please enter message !", duration: .short)
            snackbar.show()
            return
       }
        let dict = ["full_name":txtfullName.text!,
                    "email":txtEmail.text!,
                    "message":txtdes.text!] as JsonDict
        if txtfullName.text ?? "" != "" && txtEmail.text ?? "" != "" && txtEmail.text?.isValidEmail == true && txtEmail.text ?? "" != "" {
            ApiClass().contactusApi(view: self.view, inputUrl: baseUrl+"contact-us", parameters: dict, header: self.userToken) { result in
                print(result)
                let data = result as? [String:Any]
                if data?["status"] as? Int ?? 0 == 1{
                    self.txtdes.text = ""
                    self.txtEmail.text = ""
                    self.txtfullName.text = ""
                }
                    let snackbar = TTGSnackbar(message: data?["message"] as? String ?? "", duration: .short)
                    snackbar.show()
            }
        }
    }

    // MARK: - Navigation
    @IBAction func didTapPhone(_ sender:UIButton){
        if let phoneCallURL = URL(string: "telprompt://\(lblPhone.text!)") {

            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                     application.openURL(phoneCallURL as URL)

                }
            }
        }
    }
    
    
//    private func callNumber(phoneNumber:String) {
//
//        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
//
//            let application:UIApplication = UIApplication.shared
//            if (application.canOpenURL(phoneCallURL)) {
//                if #available(iOS 10.0, *) {
//                    application.open(phoneCallURL, options: [:], completionHandler: nil)
//                } else {
//                    // Fallback on earlier versions
//                     application.openURL(phoneCallURL as URL)
//
//                }
//            }
//        }
//    }
    
    func sendMail()
    {
        if MFMailComposeViewController.canSendMail()
        {
            let message:String  = "Changes in mail composer ios 11"
            let composePicker = MFMailComposeViewController()
            composePicker.mailComposeDelegate = self
            composePicker.delegate = self
                composePicker.setToRecipients([self.lblemail.text!])
            composePicker.setSubject("")
            composePicker.setMessageBody(message, isHTML: false)
            self.present(composePicker, animated: true, completion: nil)
            } else {
            self .showErrorMessage()
        }
    }
    
    
    func showErrorMessage() {
        let alertMessage = UIAlertController(title: "could not sent email", message: "check if your device have email support!", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title:"Okay", style: UIAlertAction.Style.default, handler: nil)
    alertMessage.addAction(action)
    self.present(alertMessage, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    switch result {
    case .cancelled:
    print("Mail cancelled")
    case .saved:
    print("Mail saved")
    case .sent:
    print("Mail sent")
    case .failed:
    break
    }
    self.dismiss(animated: true, completion: nil)
    }
}
//import UIKit
@IBDesignable class TextViewWithPlaceholder: UITextView {
    
    override var text: String! { // Ensures that the placeholder text is never returned as the field's text
        get {
            if showingPlaceholder {
                return "" // When showing the placeholder, there's no real text to return
            } else { return super.text }
        }
        set { super.text = newValue }
    }
    @IBInspectable var placeholderText: String = ""
    @IBInspectable var placeholderTextColor: UIColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0) // Standard iOS placeholder color (#C7C7CD). See https://stackoverflow.com/questions/31057746/whats-the-default-color-for-placeholder-text-in-uitextfield
    private var showingPlaceholder: Bool = true // Keeps track of whether the field is currently showing a placeholder
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if text.isEmpty {
            showPlaceholderText() // Load up the placeholder text when first appearing, but not if coming back to a view where text was already entered
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        // If the current text is the placeholder, remove it
        if showingPlaceholder {
            text = nil
            textColor = nil // Put the text back to the default, unmodified color
            showingPlaceholder = false
        }
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        // If there's no text, put the placeholder back
        if text.isEmpty {
            showPlaceholderText()
        }
        return super.resignFirstResponder()
    }
    
    private func showPlaceholderText() {
        showingPlaceholder = true
        textColor = placeholderTextColor
        text = placeholderText
    }
}
