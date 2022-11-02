//
//  ProfileUpdateViewModal.swift
//  JabyJob
//
//  Created by DMG swift on 22/02/22.
//

import Foundation
import UIKit
import TTGSnackbar

class ProfileUpdateViewModal {

    weak var VC : EditProfileVC?
   private var isValidation = false
    func changePassValidation(){
        if VC?.txtNewPass.text! == "" {
            VC?.txtNewPass.setError("Please enter new password !", show: false)
           isValidation = false
        }
        if VC?.txtConfrimPass.text! == "" {
            VC?.txtConfrimPass.setError("Please enter confrim password !", show: false)
            isValidation = false
        }
        if VC?.txtoldPass.text! == "" {
            VC?.txtoldPass.setError("Please enter current password !", show: false)
            isValidation = false
        }
        if VC?.txtNewPass.text != VC?.txtConfrimPass.text {
            VC?.txtConfrimPass.setError("Passsword dose not match !", show: false)
            isValidation = false
        }else {
            isValidation = true
        }
        let dict = ["new_password":VC?.txtNewPass.text ?? "",
                    "new_password_confirmation":VC?.txtConfrimPass.text ?? "",
                    "current_password":VC?.txtoldPass.text ?? ""]
        
        if VC?.txtNewPass.text != "" && VC?.txtConfrimPass.text != "" && VC?.txtoldPass.text != "" && isValidation == true {
            ApiClass().changePasswordApi(view: (VC?.view)!, inputUrl: baseUrl+"change-password", parameters: dict, header:VC?.userToken ?? "") { result in
                print(result)
                let dict = result as? [String:Any]
                let snackbar = TTGSnackbar(message: dict?["message"] as? String ?? "", duration: .short)
                snackbar.show()
                if dict?["status"] as? Int ?? 0 == 1 {
                    self.VC?.PopUpMain_View.isHidden = true
                }
            }
            print("sucess")
        }
        
    }
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    func editProfileApi(){
        var dict = JsonDict()
        
        let img = "data:image/jpeg;base64," + (self.VC?.Userimage ?? "")
//        let image = convertImageToBase64String(img:pdfImage!)
        if VC?.Userimage != "" {
            dict = ["full_name":self.VC?.txtname.text ?? "","username":self.VC?.txtuserName.text ?? "","country":self.VC?.countryIds ?? 0,"email":self.VC?.txtEmail.text ?? "","category_id":self.VC?.categoryId[0] ?? 0,"skill":self.VC?.id ?? 0,"image":img,"country_code":VC?.countryCodeId ?? 0,"role_id":VC?.roleId ?? 0,"phone":VC?.txtMobile.text ?? ""]
        }else {
            dict = ["full_name":self.VC?.txtname.text ?? "","username":self.VC?.txtuserName.text ?? "","country":self.VC?.countryIds ?? 0,"email":self.VC?.txtEmail.text ?? "","category_id":self.VC?.categoryId[0] ?? 0,"skill":self.VC?.id ?? 0,"country_code":VC?.countryCodeId ?? 0,"role_id":VC?.roleId ?? 0,"phone":VC?.txtMobile.text ?? ""]
        }
            ApiClass().updateProfileApi(view: (self.VC?.view)!, inputUrl: baseUrl+"update-profile", parameters: dict, header: self.VC?.userToken ?? "") { result in
                
                let dict  = result as? JsonDict
                
                let snackbar = TTGSnackbar(message: dict?["message"] as? String ?? "", duration: .short)
                snackbar.show()
                
                DispatchQueue.global().sync {()
                    
                    NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["userImage":self.VC!.userImg.image!])
                }
                print(result)
            }
//        }
        
    }
    
}
