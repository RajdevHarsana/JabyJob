//
//  VerificationVC.swift
//  JabyJob
//
//  Created by Arkamac1 on 11/01/22.
//

import UIKit

class VerificationVC: BaseViewController {
    
    @IBOutlet weak var CornorMain_view: UIView!
    @IBOutlet weak var txtOnePass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfrimPass: UITextField!
    
     var verificationViewModal = VerificationViewModal()
     var userId = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        verificationViewModal.VC = self
        txtOnePass.delegate = self
        txtNewPass.delegate = self
        txtConfrimPass.delegate = self
        CornorMain_view.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 2.0, opacity: 0.35)
        
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
           return true
    }
    @IBAction func didTapBack(_sender:UIButton) {
        verificationViewModal.setEmptyErroMsg()
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapHome(_sender:UIButton) {
        verificationViewModal.validationsOnFields()
    }
    
    @IBAction func didTapOtp(_sender:UIButton){
        verificationViewModal.resendOtp()
    }
}
// Validation textFields
extension VerificationVC: UITextFieldDelegate {
    // Remove error message after start editing
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.setError(nil, show: false)
        return true
    }
}
