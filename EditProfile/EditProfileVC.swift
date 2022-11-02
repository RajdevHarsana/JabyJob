//
//  EditProfileVC.swift
//  Demo-push
//
//  Created by Arkamac1 on 11/01/22.
//

import UIKit
import iOSDropDown
import TTGSnackbar
import MobileCoreServices
import SDWebImage




// Validation textFields
extension EditProfileVC: UITextFieldDelegate {
   
    
    // Remove error message after start editing
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == txtNewPass || textField == txtConfrimPass || textField == txtoldPass {
                    textField.setError(nil, show: false)
                    return true
//        }
    }
}

class EditProfileVC: BaseViewController, countryName, countryPhoneCode {
    func countryCode(countryId: [String : Any]) {
        print(countryId)
        
        if isSeelctCountry == false{
        
        countryData.removeAll()
        countryIds.removeAll()
        countryName.removeAll()
        self.countryData.append(countryId["id"] as? Int ?? 0)
        self.countryName.append(countryId["name"] as? String ?? "")
        self.countryIds = countryData
        self.txtCountry.text = countryId["name"] as? String ?? ""
        }else {
            self.countryCodeId = countryId["phonecode"] as? Int ?? 0
            let strCounty = "+" + "\(countryId["phonecode"] as? Int ?? 0)"
            self.btnCountryCode.setTitle(strCounty, for: .normal)
            
        }
    }
    
    func countryName(countryId: [String : Any]) {
        print(countryId)
    }
    
    func multipalCountryName(countryNames: [[String : Any]]) {
        countryData.removeAll()
        countryIds.removeAll()
        countryName.removeAll()
        countryNames.compactMap { list in
            self.countryData.append(list["id"] as? Int ?? 0)
            self.countryName.append(list["name"] as? String ?? "")
        }
        
        self.countryIds = countryData

        if self.countryName.count > 2 {
            self.txtCountry.text = "\(self.countryName.count) countries selected"
        }else {
            self.txtCountry.text = self.countryName.map{String($0)}.joined(separator: ",")
        }
        
       
        print(countryNames)
    }
    @IBOutlet weak var btnOkay: UIButton!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var PopUpMain_View: UIView!
    @IBOutlet weak var PopUp_View: UIView!
    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfrimPass: UITextField!
    @IBOutlet weak var txtoldPass: UITextField!
    @IBOutlet weak var txtuserName: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtInterest: UITextField!
    @IBOutlet weak var txtRole: UITextField!
    @IBOutlet weak var txtSkill: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var roleImage: UIImageView!
    @IBOutlet weak var skillView: UIView!
    @IBOutlet weak var switchView: UIView!
   
    @IBOutlet weak var lblChangeRole: UILabel!
    @IBOutlet weak var tblCategory: UITableView!
    @IBOutlet weak var changePassBottomConst: NSLayoutConstraint!
    var imagPickUp : UIImagePickerController!
    var countryName = [String]()
    var categoryData = [[String:Any]]()
    var skillData = [[String:Any]]()
//    var catId = Int()
    var categoryName = [String]()
    var id = [Int]()
    var skillNames = [String]()
    var countryIds = [Int]()
    var cate = false
    var isCallOnce = false
    var skillCallOnece = false
    var userSkillData = JsonDict()
    var skilids = [Int]()
    var updateProfileViewModal = ProfileUpdateViewModal()
    var categoryId = [Int]()
    var sendUserImg = UIImageView()
    var isCameraImageClick = false
    var Userimage = String()
    var presentNavigation:UINavigationController?
    var isSeelctCountry = false
    var countryCodeId = Int()
    var roleId = Int()
    var updateProfileDelegate: updateUserProfile? = nil
    var isEditFromSide = false
    //self.convertImageToBase64String(img:userImgeUploade)
    override func viewDidLoad() {
        super.viewDidLoad()
//        userImg.contentMode = .scaleToFill
        isCallOnce = false
        PopUpMain_View.isHidden = true
        self.PopUp_View.RoundCorner([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 10.0, borderColor: UIColor.clear, borderWidth: 0)
        
        self.btnSave.RoundCorner([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 45, borderColor: UIColor.clear, borderWidth: 0)
      
        skillView.DropShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.gray, radius: 3.0, opacity: 0.50)
        self.btnOkay.RoundCorner([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 45, borderColor: UIColor.clear, borderWidth: 0)
        
        txtname.delegate = self
        txtuserName.delegate = self
        txtConfrimPass.delegate = self
        txtNewPass.delegate = self
        txtoldPass.delegate = self
        
        
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        changePassBottomConst.constant = 335
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        changePassBottomConst.constant = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
           return true
    }
    
    
    @IBAction func didTapOkay(_sender:UIButton){
        self.switchView.isHidden = true
        
        
        if roleId == 2 {
            roleId = 3
        }else {
            roleId = 2
        }
        
        
        if self.roleId == 2 {
            self.txtRole.text = "Job Seeker"
            self.roleImage.isHidden = true
        }else {
            self.txtRole.text = "Overseas Job Applicant"
            self.roleImage.isHidden = false
        }
        
        
        
    }
    @IBAction func didTapSwitch(_sender:UIButton){
        self.switchView.isHidden = false
        
        if self.roleId == 2 {
          
            lblChangeRole.font = UIFont(name: "Montserrat-Regular", size: 17.0)
            lblChangeRole.textColor = #colorLiteral(red: 0.1686112285, green: 0.1686365306, blue: 0.1686026156, alpha: 1)
    //        let text = "This is a colorful attributed string"
            let text = "Are you sure you want to switch account from Job Seeker to "
            let text1 = "Overseas Job Applicant"
            //78
            let attrStri = NSMutableAttributedString.init(string:text)
                let nsRange = NSString(string:text).range(of: "Job Seeker", options: String.CompareOptions.caseInsensitive)

            attrStri.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(named: "brownishGrey")!, NSAttributedString.Key.font: UIFont.init(name: "Montserrat-SemiBold", size: 16.0) as Any], range: nsRange)


            let attrStri1 = NSMutableAttributedString.init(string:text1)
                let nsRange1 = NSString(string:text1 ).range(of: "Overseas Job Applicant", options: String.CompareOptions.caseInsensitive)

            attrStri1.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(named: "reddishOrange")!, NSAttributedString.Key.font: UIFont.init(name: "Montserrat-SemiBold", size: 16.0) as Any], range: nsRange1)
            attrStri.append(attrStri1)
            lblChangeRole.attributedText = attrStri
        }else {
            lblChangeRole.font = UIFont(name: "Montserrat-Regular", size: 17.0)
            lblChangeRole.textColor = #colorLiteral(red: 0.1686112285, green: 0.1686365306, blue: 0.1686026156, alpha: 1)
    //        let text = "This is a colorful attributed string"
            let text = "Are you sure you want to switch account from Overseas Job Applicant to "
            let text1 = "Job Seeker"
            //78
            let attrStri = NSMutableAttributedString.init(string:text)
                let nsRange = NSString(string: text).range(of: "Overseas Job Applicant", options: String.CompareOptions.caseInsensitive)

            attrStri.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(named: "brownishGrey")!, NSAttributedString.Key.font: UIFont.init(name: "Montserrat-SemiBold", size: 16.0) as Any], range: nsRange)


            let attrStri1 = NSMutableAttributedString.init(string:text1)
                let nsRange1 = NSString(string:text1 ).range(of: "Job Seeker", options: String.CompareOptions.caseInsensitive)

            attrStri1.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(named: "reddishOrange")!, NSAttributedString.Key.font: UIFont.init(name: "Montserrat-SemiBold", size: 16.0) as Any], range: nsRange1)
            attrStri.append(attrStri1)
            lblChangeRole.attributedText = attrStri
        }
        

        
        
        
    }
    
    @IBAction func didTapClose(_sender:UIButton){
        self.switchView.isHidden = true
    }
    @IBAction func didtapCountryList(_sender:UIButton){
        isSeelctCountry = true
//        countryType = 0
        let storyboard = UIStoryboard(name: "Country", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CountryPickerVC") as! CountryPickerVC
        vc.delegateCountryCode = self
//        vc.delegageCountryName = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.switchView.isHidden = true
        txtNewPass.delegate = self
        txtoldPass.delegate = self
        txtConfrimPass.delegate = self
        skillView.isHidden = true
        updateProfileViewModal.VC = self
        _ = imageAndVideos()
        SDImageCache.shared.clearMemory()//sharedImageCache.clearMemory()
//        SDImageCache.shared.sharedImagech//sharedImageCache().clearDisk()
        userSkillData = self.logeedInUsessrData["data"] as? [String:Any] ?? [:]
        skilids = userSkillData["skill"] as? [Int] ?? []
        self.roleId = userData["role_id"] as? Int ?? 0
        
        if self.roleId == 2 {
            self.txtRole.text = "Job Seeker"
            self.roleImage.isHidden = true
        }else {
            self.txtRole.text = "Overseas Job Applicant"
            self.roleImage.isHidden = false
        }
        
        self.txtEmail.text = userData["email"] as? String ?? ""
//        self.userImg.image = nil
        var newLink = self.userData["image"] as? String ?? ""
       
        newLink = newLink.replacingOccurrences(of: " ", with: "%20")
//        self.txtMobile.text =  "\(self.userData["phone"] as! Int)"
        self.btnCountryCode.setTitle("+ \(self.userData["country_code"] as? Int ?? 0)", for: .normal)
        countryCodeId = self.userData["country_code"] as? Int ?? 0
        
       if self.isCameraImageClick == false {
           DispatchQueue.global().sync {
               
               self.userImg.downloadImage(url: newLink)
               
//                self.userImg.sd_setImage(with: URL(string:newLink), placeholderImage: UIImage(named: "avatar"), options: .refreshCached) { (image, error, cacheType, url) in
//                            self.userImg.image = image
//                        }
            }
            self.sendUserImg.image = self.userImg.image
           countryApi()
           self.txtname.text = userData["full_name"] as? String ?? ""
           self.txtuserName.text = userData["username"] as? String ?? ""
           self.txtMobile.text = userData["phone"] as? String ?? ""
           self.txtCountry.text = userData["phone"] as? String ?? ""
        }
       
//        userImg.contentMode = .scaleToFill
       

//        self.userImg.sd_setImage(with: URL(string: userData["image"] as? String ?? ""), placeholderImage: UIImage(named: "avatar"),options: .refreshCached)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
       
    }
    func imageAndVideos()-> UIImagePickerController{
        if(imagPickUp == nil){
            imagPickUp = UIImagePickerController()
            imagPickUp.delegate = self
            imagPickUp.allowsEditing = false
        }
        return imagPickUp
    }
    @IBAction func didTapCountryPicker(_ sender: UIButton) {
        isSeelctCountry = false
//        if userRoll == 2 {
            let storyboard = UIStoryboard(name: "Country", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CountryPickerVC") as! CountryPickerVC
              
            vc.delegageCountryName = self
            vc.delegateCountryCode = self
            vc.priviousSelectdData = self.countryIds
            if userRoll == 2 {
                vc.isCountryName = false
            }else {
                vc.isCountryName = false
            
            }
        self.present(vc, animated: true, completion: nil)
//        }else {
//
//        }
        
//        PopUpMain_View.isHidden = false
    }
    @IBAction func btnDidTapBack(_ sender: UIButton) {
       
        self.dismiss(animated: true) {
            self.updateProfileDelegate?.udpateUserData()
        }
    }
    
    @IBAction func btn_changepasword(_ sender: UIButton) {
        self.txtoldPass.text = ""
        self.txtNewPass.text = ""
        self.txtConfrimPass.text = ""
        PopUpMain_View.isHidden = false
    }
    @IBAction func close_popup(_ sender: UIButton) {
        PopUpMain_View.isHidden = true
        self.txtoldPass.setError(nil, show: false)
        self.txtNewPass.setError(nil, show: false)
        self.txtConfrimPass.setError(nil, show: false)
    }
    @IBAction func didTapSave(_ sender: UIButton) {
        if txtInterest.text ?? "" == "General (All)" {
            updateProfileViewModal.editProfileApi()
        }else if id.count == 0 {
            let snackbar = TTGSnackbar(message:"Please select skill.", duration: .short)
            snackbar.show()
        }else {
            updateProfileViewModal.editProfileApi()
        }
       
        //PopUpMain_View.isHidden = true

    }
    
    @IBAction func didTapSavePassword(_ sender: UIButton) {
       updateProfileViewModal.changePassValidation()
    }
    
    @IBAction func didTapInterest(_sender:UIButton){
        
//
        skillView.isHidden = false
        self.categoryApi()
        self.cate = false
        self.tblCategory.reloadData()
    }
    
    @IBAction func didTapSkill(_sender:UIButton){
        
        if skillData.count == 0 {
//            let snackbar = TTGSnackbar(message:"General have no skills", duration: .short)
//            snackbar.show()
        }else {
            skillView.isHidden = false
            self.cate = true
        }
        self.tblCategory.reloadData()
    }
    @IBAction func didTapDone(_sender:UIButton){
        skillView.isHidden = true
        if self.cate == false{
            txtSkill.text = ""
            self.skilids.removeAll()
            self.cate = true
            self.categoryId.removeAll()
            for i in 0..<self.categoryData.count {
                if self.categoryData[i]["isSelect"] as? Bool == true{
                    self.categoryId.append(self.categoryData[i]["id"] as? Int ?? 0)
                    self.txtInterest.text = self.categoryData[i]["title"] as? String ?? ""
                    self.userData["category_id"] = self.categoryData[i]["id"] as? Int ?? 0
                    self.skillApi(catid: self.categoryData[i]["id"] as? Int ?? 0)
                }
            }
        }else {
            self.categoryName.removeAll()
            self.id.removeAll()
            self.skilids.removeAll()
            self.skillData.compactMap { list in
                if list["isSelect"] as? Bool == true{
                    categoryName.append(list["name"] as? String ?? "")
                    id.append(list["id"] as? Int ?? 0)
                }
            }
            skilids = id
            txtSkill.text = categoryName.map{String($0)}.joined(separator: ",")
            self.cate = false
        }
    }
    @IBAction func didTapCancel(_sender:UIButton){
        skillView.isHidden = true
//        skillView.animHide()
       
    }
    
    @IBAction func Btn_UploadVideo(_ sender: UIButton) {
        let ActionSheet = UIAlertController(title: nil, message: "Select Photo", preferredStyle: .actionSheet)

          let cameraPhoto = UIAlertAction(title: "Camera", style: .default, handler: {
              (alert: UIAlertAction) -> Void in
              if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                  self.isCameraImageClick = true
                  self.imagPickUp.mediaTypes = ["public.image"]
                  self.imagPickUp.sourceType = UIImagePickerController.SourceType.camera;
                  
                  self.present(self.imagPickUp, animated: true, completion: nil)
              }
              else{
                  UIAlertController(title: "iOSDevCenter", message: "No Camera available.", preferredStyle: .alert).show(self, sender: nil);
              }

          })

          let PhotoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: {
              (alert: UIAlertAction) -> Void in
              if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                  self.imagPickUp.mediaTypes = ["public.image"]
                  self.imagPickUp.sourceType = UIImagePickerController.SourceType.photoLibrary;
                  self.present(self.imagPickUp, animated: true, completion: nil)
              }

          })

          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
              (alert: UIAlertAction) -> Void in

          })

          ActionSheet.addAction(cameraPhoto)
          ActionSheet.addAction(PhotoLibrary)
          ActionSheet.addAction(cancelAction)


          if UIDevice.current.userInterfaceIdiom == .pad{
              let presentC : UIPopoverPresentationController  = ActionSheet.popoverPresentationController!
              presentC.sourceView = self.view
              presentC.sourceRect = self.view.bounds
              self.present(ActionSheet, animated: true, completion: nil)
          }
          else{
              self.present(ActionSheet, animated: true, completion: nil)
          }
    }
    
    
    //MARK :- Api
    func categoryApi(){
        ApiClass().categoryApi(view: self.view, BaeUrl: baseUrl+"category", paramters: [:]) { result in
            self.categoryData.removeAll()
            self.categoryId.removeAll()
            let dict = result as? [String:Any] ?? [:]
            self.categoryData = dict["data"] as? [[String:Any]] ?? [[:]]
            for i in 0..<self.categoryData.count {

                if self.categoryData[i]["id"] as? Int ?? 0 == self.userData["category_id"] as? Int ?? 0 {
                    self.categoryData[i]["isSelect"] = true
                   
                    self.userData["category_id"] = self.categoryData[i]["id"] as? Int ?? 0
//                    if self.isCallOnce == false {
                        self.categoryId.append(self.userData["category_id"] as? Int ?? 0)
                        self.cate = false
                        if self.userData["category_id"] as? Int ?? 0 != 1{
                            
                            
//                            self.txtSkill.placeholder = "No skill listed"
                            self.skillApi(catid: self.userData["category_id"] as? Int ?? 0)
                        }else {
                            self.txtSkill.placeholder = "No skill listed"
                        }
                        
                        self.isCallOnce = true
//                    }
                    self.txtInterest.text = self.categoryData[i]["title"] as? String ?? ""
                  
                }else {
                    self.categoryData[i]["isSelect"] = false
                }
                if self.categoryData[i]["title"] as? String ?? "" == "General" {
                    self.categoryData.insert(self.categoryData[i], at: 0)
                    self.categoryData.remove(at:i+1)
                   }
            }
            self.tblCategory.reloadData()

        }
    }
  
    func skillApi(catid: Int)  {
      
        let param = ["category_id":catid]
        ApiClass().skillApi(view: self.view, BaeUrl: baseUrl+"skill", paramters: param as JsonDict) { result in
            print(result)
            self.skillData.removeAll()
            self.categoryName.removeAll()
            self.id.removeAll()
            //                self.skilids.removeAll()
            let dict = result as? [String:Any] ?? [:]
            if dict["status"] as? Int ?? 0 == 1 {
                
                self.skillData = dict["data"] as? [[String:Any]] ?? [[:]]
            
                if self.skillData.count > 0  {
                    self.txtSkill.placeholder = "Select skill"
//                    let skilids = self.userData["skill"] as? [Int]
                    for i in 0..<self.skillData.count {
//                        self.cate = true
                        if self.skilids.count > 0 {
                            let id = self.skillData[i]["id"] as? Int ?? 0
                            if self.skilids.contains(id){
                                self.skillData[i]["isSelect"] = true
                            }else {
                                self.skillData[i]["isSelect"] = false
                            }
                        }else {
                            self.skillData[i]["isSelect"] = false
                        }
                        
                    }
//
                    
//                    var categoryName = [String]()
//                    var id = [Int]()
                   _ = self.skillData.compactMap { list in
                       if list["isSelect"] as? Bool == true{
                           self.categoryName.append(list["name"] as? String ?? "")
                           self.id.append(list["id"] as? Int ?? 0)
                       }
                    }
                    self.txtSkill.text = self.categoryName.map{String($0)}.joined(separator: ",")
                }
               
            }else {
                self.txtSkill.placeholder = "No skill listed"
            }
            self.tblCategory.reloadData()
        }
    }
    
    func countryApi(){
        ApiClass().countryApi(view: self.view, BaeUrl:baseUrl+"country", paramters: [:]) { result in
            print(result)
            self.countryIds.removeAll()
            self.countryName.removeAll()
            let countrydata = result as? [String:Any] ?? [:]
            let matchData = countrydata["data"] as? [[String:Any]] ?? [[:]]
            self.countryName.removeAll()
            for i in 0..<matchData.count {
                let id = matchData[i]["id"] as! Int
                if self.userData["country_id"] as? Int ?? 0 == id {
                    self.txtMobile.text =  "\(self.userData["phone"] as! Int)"
                    self.txtCountry.text = matchData[i]["name"] as? String
//                    self.countryCodeId = matchData[i]["phonecode"] as! Int
                    self.countryIds.append(id)
//                    self.countryCodeId = id
                    
                   // self.btnCountryCode.setTitle("\(matchData[i]["phonecode"] as! Int)", for: .normal)
                }
                if self.countryData.contains(id){
                    self.countryIds.append(id)
                    self.countryName.append(matchData[i]["name"] as! String)
                }
            }
            if self.countryName.count > 2 {
                self.txtCountry.text = "\(self.countryName.count) countries selected"
            }else {
//                self.txtCountry.text = self.countryName.map{String($0)}.joined(separator: ",")
            }
            self.categoryApi()
            
//            self.txtCountry.text = self.countryName.map{String($0)}.joined(separator: ",")
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
   
}

extension EditProfileVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.cate == false{
           return self.categoryData.count
        }else {
            return self.skillData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        
        if self.cate == false{
            cell.lblName.text = self.categoryData[indexPath.row]["title"] as? String ?? ""
            if self.categoryData[indexPath.row]["isSelect"] as? Bool == true {
                cell.checkImg.image = #imageLiteral(resourceName: "checked")
            }else {
                cell.checkImg.image = UIImage(named: "")
            }
        }else {
            cell.lblName.text = self.skillData[indexPath.row]["name"] as? String ?? ""
            
            if self.skillData[indexPath.row]["isSelect"] as? Bool == true {
                cell.checkImg.image = #imageLiteral(resourceName: "checked")
            }else {
                cell.checkImg.image = UIImage(named: "")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.cate == false{
            for i in 0..<self.categoryData.count {
                if self.categoryData[i]["isSelect"] as? Bool == true {
                    self.categoryData[i]["isSelect"] = false
                }
            }
            self.categoryData[indexPath.row]["isSelect"] = true
            self.tblCategory.reloadData()

        }else {
            
            if skillData[indexPath.row]["isSelect"] as? Bool == false {
                skillData[indexPath.row]["isSelect"] = true
            }else {
                skillData[indexPath.row]["isSelect"] = false
            }
            
            self.tblCategory.reloadData()

        }

    }
    
    
}
extension EditProfileVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.sendUserImg.image = image!
        self.userImg.image = image
        userImgeUploade = image!
        DispatchQueue.global().sync {
            self.Userimage = updateProfileViewModal.convertImageToBase64String(img:image!)
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["userImage":image!])
        }
        
       


        
        
//        self.userImg.contentMode = .scaleToFill
        self.isCameraImageClick = true
//        ApiClass().uploadImageData(view: self.view, inputUrl: baseUrl+"update-image", parameters: [:], imageName: "image", imageFile:image!, header: self.userToken) { result in
//            self.isCameraImageClick = false
//            let dict = result as? JsonDict
//            self.userData["image"] = dict?["image"] as? String ?? ""
////                   print(result)
//               }
        picker.dismiss(animated: false, completion: nil)
//        imagPickUp.dismiss(animated: true, completion: { () -> Void in
//
//        })

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagPickUp.dismiss(animated: true, completion: { () -> Void in
            // Dismiss
        })
    }
}


