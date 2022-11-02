//
//  ForgotPasswordVC.swift
//  JabyJob
//
//  Created by Arkamac1 on 11/01/22.
//

import UIKit

class ForgotPasswordVC: BaseViewController {
    @IBOutlet weak var txtMobileNum: UITextField!
    @IBOutlet weak var CornorMain_view: UIView!
    var forgotPassViewModal = FortgotPassViewModal()
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotPassViewModal.VC = self
        txtMobileNum.delegate = self
        CornorMain_view.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 2.0, opacity: 0.35)
       
    }
   

    @IBAction func didTaplogin(_sender:UIButton) {
        txtMobileNum.setError(nil, show: false)
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func didTapBack(_sender:UIButton) {
        txtMobileNum.setError(nil, show: false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapVerification(_sender:UIButton) {
        
        if txtMobileNum.text?.isValidEmail == false{
            txtMobileNum.setError("Please enter valid email address !", show: false)
            return
        }else {
            forgotPassViewModal.validateField()
        }
        
    }
    
}
// Validation textFields
extension ForgotPasswordVC: UITextFieldDelegate {
    // Remove error message after start editing
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.setError(nil, show: false)
        return true
    }
}
