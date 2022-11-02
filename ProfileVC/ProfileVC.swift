//
//  ProfileVC.swift
//  Demo-push
//
//  Created by Arkamac1 on 10/01/22.
//

import UIKit
import MobileCoreServices
import AVFoundation
import PDFKit
import AVKit
import TTGSnackbar
import SDWebImage

protocol updateUserProfile{
    func udpateUserData()
}
var userImgeUploade = UIImage()
class ProfileVC: UIViewController,updateUserProfile {
    
    
    
    //    @IBOutlet weak var Btn_EditProfile: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btndismiss: UIButton!
    @IBOutlet weak var Btn_Plus: UIButton!
    @IBOutlet weak var UploadView: UIView!
    @IBOutlet weak var UploadSuccessView: UIView!
    @IBOutlet weak var Btn_ImageUpload: UIButton!
    @IBOutlet weak var Btn_DocUpload: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnDoc: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblSucces: UILabel!
    @IBOutlet weak var lblCvPercent: UILabel!
    let pickerController = UIImagePickerController()
    @IBOutlet weak var colletionMy: UICollectionView!
    @IBOutlet weak var videoProcess: UIProgressView!
    @IBOutlet weak var videoIma: UIImageView!
    @IBOutlet weak var cvImage: UIImageView!
    @IBOutlet weak var UserTypeImage: UIImageView!
    @IBOutlet weak var paymentPopUp: UIView!
    var isDocrOrVideo = false
    var viedosData = NSArray()
    var cvPath = [String]()
    var isVideoUploaindg = true
    var isCvUploaindg = true
    private var videoPer = false
    private var cvPer = false
    var count = 0
    var userToken = ""
    var pdfViewUrl = ""
    private let videoCompressor = LightCompressor()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    let playerController = AVPlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.paymentPopUp.isHidden = true
       
        
        //        DispatchQueue.global().sync {
        UploadSuccessView.isHidden = true
        self.videoProcess.isHidden = true
        self.lblCvPercent.isHidden = true
        let gestureRecognizerOne = UITapGestureRecognizer(target: self, action: #selector(Btn_UploadVideo))
        let gestureRecognizerTwo = UITapGestureRecognizer(target: self, action: #selector(BtnulopadCV))
        cvImage.addGestureRecognizer(gestureRecognizerTwo)
        videoIma.addGestureRecognizer(gestureRecognizerOne)
        btnVideo.backgroundColor = UIColor(named: "white - Three")
        btnDoc.backgroundColor = .white
        btnDoc.borderWidth = 0.7
        btnDoc.borderColor = UIColor(named: "white - Three")
        isDocrOrVideo = false
        
        UploadView.isHidden = true
        
        Btn_Plus.layer.cornerRadius = 6
        UploadView.layer.cornerRadius = 15
        
        
        //        Btn_ImageUpload.layer.cornerRadius = 46
        //        Btn_ImageUpload.layer.borderColor = UIColor.gray.cgColor
        //        Btn_ImageUpload.layer.borderWidth = 1
        //
        //        Btn_DocUpload.layer.cornerRadius = 46
        //        Btn_DocUpload.layer.borderColor = UIColor.gray.cgColor
        //        Btn_DocUpload.layer.borderWidth = 1
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
       
        
        
        btnEdit.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
        userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
        
        self.userProfile()
        //        }
        
    }
    
    @IBAction func didTapBack(_sender:UIButton) {
        self.tabBarController?.selectedIndex = 0
        self.tabBarController?.tabBar.isHidden = false
        let objToBeSent = true
        NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: objToBeSent)
    }
    
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        print(notification)
        let image = notification.userInfo as? [String:Any]
        let userImage = image?["userImage"] as? UIImage
        self.userImg.image = userImage
    }
    
    func udpateUserData() {
        userProfile()
    }
    
    
    func userProfile(){
        
        ApiClass().getUserProfile(view: self.view, inputUrl:  baseUrl+"profile", parameters: [:], header: userToken) { result in
            let dict = result as? [String:Any]
            print(dict)
            self.cvPath.removeAll()
            
            if dict?["status"] as? Int ?? 0 == 1 {
                
                self.cvPath.removeAll()
                let data = dict?["data"] as? [String:Any]
                let userData = data?["user"] as? JsonDict
                //#MARK: ajeet change lblemail(email) to user name by abhishek sir
              
                let name = userData?["username"] as? String ?? ""
                self.lblEmail.text = "@" + name
                
                self.cvPath.append(userData?["cv_thumbnail"] as? String ?? "")
                self.pdfViewUrl = userData?["cv"] as? String ?? ""
                self.viedosData = dict?["video"] as? NSArray ?? []
                self.count = self.viedosData.count
                var newLink = userData?["image"] as? String ?? ""
                newLink = newLink.replacingOccurrences(of: " ", with: "%20")
                self.userImg.downloadImage(url: newLink)
                self.colletionMy.reloadData()
                let roleId = userData?["role_id"] as? Int ?? 0
                if roleId == 2 {
                    self.UserTypeImage.isHidden = true
                }else {
                    self.UserTypeImage.isHidden = false
                }
                self.clearUserData()
                UserDefaults.standard.set(1, forKey: "UserLogin")
                UserDefaults.standard.set(dict!, forKey: "userData")
                
                //                self.clearUserData()
                //                UserDefaults.standard.set(dict!, forKey: "userData")
                //                print("successHeere")
            }
        }
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        btnEdit.isEnabled = true
        NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: false)
        DispatchQueue.main.async {
            self.userProfile()
            //            self.lblEmail.text = self.userData["email"] as? String ?? ""
            //            self.userImg.image = userImgeUploade
            //            self.userImg.downloadImage(url: self.userData["image"] as? String ?? "")
            
        }
        
    }
    
    @objc func didTapProfile(){
        let storyboard = UIStoryboard(name: "EditProfile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        vc.modalPresentationStyle = .overFullScreen
        vc.presentNavigation = self.navigationController
        vc.updateProfileDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func BtnulopadCV() {
        isDocrOrVideo = true
        if isVideoUploaindg == false {
            let snackbar = TTGSnackbar(message: "Please wait while uploding Video.", duration: .short)
            snackbar.show()
        }else {
            let types = [kUTTypePDF,"com.microsoft.word.doc" as CFString, "org.openxmlformats.wordprocessingml.document" as CFString]
            let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
            
            if #available(iOS 11.0, *) {
                importMenu.allowsMultipleSelection = true
            }
            
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            
            present(importMenu, animated: true)
        }
        
        
        
    }
    
    @objc func Btn_UploadVideo() {
        self.videoProcess.setProgress(0.0, animated: false)
        if self.count == 5 {
            let snackbar = TTGSnackbar(message: "Maximum video uploading limit is five you have been done.", duration: .short)
            snackbar.show()
        }else {
            
            self.userImg.borderColor = nil
            isDocrOrVideo = false
            if isCvUploaindg == false {
                let snackbar = TTGSnackbar(message: "Please wait while uploding CV.", duration: .short)
                snackbar.show()
            }else {
                
                if  self.videoPer == false {
                    pickerController.sourceType = .savedPhotosAlbum
                    pickerController.accessibilityPath?.miterLimit = 3
                    // Must import `MobileCoreServices`
                    // Part 2: Allow user to select both image and video as source
                    pickerController.mediaTypes = [kUTTypeMovie as String]
                    
                    // Part 3: User can optionally crop only a certain part of the image or video with iOS default tools
                    pickerController.allowsEditing = true
                    pickerController.videoMaximumDuration = 180
                    // Part 4: For callback of user selection / cancellation
                    pickerController.delegate = self
                    
                    // Part 5: Show UIImagePickerViewController to user
                    present(pickerController, animated: true, completion: nil)
                }else {
                    let snackbar = TTGSnackbar(message: "Please wait while uploding video.", duration: .short)
                    snackbar.show()
                }
            }
        }
    }
    
    @IBAction func didTapHide(_ sender:UIButton){
        self.paymentPopUp.isHidden = true
    }
    @IBAction func didTapGoToPlan(_ sender:UIButton){
        let storyboard = UIStoryboard(name: "Subscriptions", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "FreeTrialVC") as! FreeTrialVC
        vc.isFromProfile = true
        self.paymentPopUp.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didatpAddMore(_ sender:UIButton){
        if payment == false {
            self.paymentPopUp.isHidden = false
        }else {
            if cvPer == false {
                self.cvImage.image = #imageLiteral(resourceName: "DoucumentRound")
                self.cvImage.borderColor = nil
                self.cvImage.borderWidth = 0
            }
            
            if self.videoPer == false {
                self.videoIma.image = #imageLiteral(resourceName: "camera-1")
                self.videoIma.borderColor = nil
                self.videoIma.borderWidth = 0
            }
            
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
            UploadView.isHidden = false
        }
    }
    
    @IBAction func didtapDismis(_ sender:UIButton){
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        UploadView.isHidden = true
    }
    
    @IBAction func didtapDemo(_ sender:UIButton){
        
        print("tapped")
    }
    
    
    @IBAction func didtapVideo(_ sender:UIButton){
        
        isDocrOrVideo = false
        //        if isCvUploaindg == false {
        //            let snackbar = TTGSnackbar(message: "Please wait while uploding CV.", duration: .short)
        //            snackbar.show()
        //        }else {
        
        //        DispatchQueue.main.sync {
        btnVideo.backgroundColor = UIColor(named: "white - Three")
        btnVideo.layer.borderWidth = 0
        btnDoc.backgroundColor = .white
        btnDoc.layer.borderWidth = 0.7
        btnDoc.borderColor = UIColor(named: "white - Three")
        colletionMy.reloadData()
        //        }
        
        
        //        }
        
        //        UploadView.isHidden = true
    }
    
    @IBAction func didtapDoc(_ sender:UIButton){
        isDocrOrVideo = true
        //        if isVideoUploaindg == false {
        //            let snackbar = TTGSnackbar(message: "Please wait while uploding Video.", duration: .short)
        //            snackbar.show()
        //        }else {
        
        btnDoc.backgroundColor = UIColor(named: "white - Three")
        btnVideo.backgroundColor = .white
        btnVideo.layer.borderWidth = 0.7
        btnDoc.layer.borderWidth = 0
        btnVideo.borderColor = UIColor(named: "white - Three")
        colletionMy.reloadData()
        //        }
        
        //        UploadView.isHidden = true
    }
    
}
extension ProfileVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @objc func didTapPlayVideo(_ sender:UIButton){
        
        //        DispatchQueue.global().sync {
        let data = self.viedosData[sender.tag] as? JsonDict
        let videoURL = URL(string: videobaseurl + (data?["name"] as? String ?? ""))
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            playerViewController.player!.automaticallyWaitsToMinimizeStalling = false
            if #available(iOS 10.0, *) {
                playerViewController.player!.playImmediately(atRate: 1.0)
            } else {
                playerViewController.player!.play()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if isDocrOrVideo == false {
            if self.viedosData.count > 0 {
                self.colletionMy.setEmptyMessage("")
                return self.viedosData.count
            }else {
                self.colletionMy.setEmptyMessage("No data found")
                return 0
                
            }
            
        }else {
            
            if self.cvPath[0] != "" {
                self.colletionMy.setEmptyMessage("")
                return self.cvPath.count
            }else {
                self.colletionMy.setEmptyMessage("No data found")
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colletionMy.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! ProfileCollCell
        cell.btnDelete.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
        
        if self.isDocrOrVideo == false{
            cell.btn_play.isHidden = false
            cell.btnDelete.isHidden = false
            let data = self.viedosData[indexPath.row] as? JsonDict
            cell.img_user.sd_setImage(with: URL(string:thumbnailbaseUrl+(data?["thumbnail"] as! String)), placeholderImage: UIImage(named: "file-video-icon-256"), options: .refreshCached) { (image, error, cacheType, url) in
                //                    self.userImg.image = image
            }
            cell.btn_play.addTarget(self, action: #selector(self.didTapPlayVideo(_:)), for: .touchUpInside)
            cell.btn_play.tag = indexPath.row
            cell.btnCVDelete.isHidden = true
            cell.btnDelete.isHidden = false
            cell.btnDelete.addTarget(self, action: #selector(self.didTapDeleteVideo(_:)), for: .touchUpInside)
            cell.btnDelete.tag = indexPath.row
            
            cell.bgView.borderWidth = 0
            
        }else {
            
            cell.bgView.borderWidth = 1
            cell.borderColor = .gray
            cell.img_user.sd_setImage(with: URL(string:self.cvPath[indexPath.row]), placeholderImage: UIImage(named: "placeholder-thumbnail-document"), options: .refreshCached) { (image, error, cacheType, url) in
                //                    self.userImg.image = image
            }
            
            cell.btnCVDelete.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
            
            cell.btnCVDelete.addTarget(self, action: #selector(self.didTapDeleteCV(_:)), for: .touchUpInside)
            cell.btnCVDelete.tag = indexPath.row
            
            //                cell.btnDelete.isHidden = false
            cell.btn_play.isHidden = true
            
            cell.btnCVDelete.isHidden = false
            cell.btnDelete.isHidden = true
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.isDocrOrVideo == true {
//            cvView.navigationDelegate = self
           
//            self.pdfView.isHidden = false
            
            
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PdfViewerVC") as! PdfViewerVC
            vc.pdfViewUrl = self.pdfViewUrl
            
    //        self.navigation?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.03, height: 125)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    @objc func didTapDeleteCV(_ sender:UIButton){
        
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure want to delete cv.", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
           
            ApiClass().deleteCVApi(view: self.view, inputUrl: baseUrl+"delete-cv", parameters: [:], header: self.userToken) { result in
                print(result)
                
                let dict = result as? JsonDict
                //            if dict?["status"] as? Int == 1 {
                self.userProfile()
                //            }
                let snackbar = TTGSnackbar(message: dict?["message"] as? String ?? "", duration: .short)
                snackbar.show()
            }
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
           print("Handle Cancel Logic here")
        
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    @objc func didTapDeleteVideo(_ sender:UIButton){
        
        
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure want to delete video.", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let data = self.viedosData[sender.tag] as? JsonDict
            let dict = ["id":data?["id"] as? Int ?? 0]
            ApiClass().deleteVideoApi(view: self.view, inputUrl: baseUrl+"delete-video", parameters: dict, header: self.userToken) { result in
                print(result)
                
                let dict = result as? JsonDict
                if dict?["status"] as? Int == 1 {
                    self.userProfile()
                }
                let snackbar = TTGSnackbar(message: dict?["message"] as? String ?? "", duration: .short)
                snackbar.show()
            }
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
           print("Handle Cancel Logic here")
        
        }))
        present(refreshAlert, animated: true, completion: nil)
      }
    
    
    func deleteVideo(){
        
        
        
    }
    
}
extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Check for the media type
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        switch mediaType {
        case kUTTypeImage:
            // Handle image selection result
            print("Selected media is image")
            //        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            ////        fooEditedImageView.image = editedImage
            //
            //        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            ////        fooOriginalImageView.image = originalImage
            
        case kUTTypeMovie:
            // Handle video selection result
            print("Selected media is video")
            isVideoUploaindg = false
            let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as! URL
            self.videoPer = true
            self.btndismiss.isUserInteractionEnabled = false
            print("Selected media is video",videoUrl)
            let data = NSData(contentsOf: videoUrl as URL)!
            let VideoLength = Double(data.length / 1048576)
//            print("File size before compression: \(Double(data.length / 1048576)) mb")
//            compressVideo(url: videoUrl)
           
            videoIma.image = self.createVideoThumbnail(from: videoUrl)
            self.btnVideo.setImage(UIImage(named: ""), for: .normal)
            //          self.btnVideo.setImage(UIImage(named: ""), for: .normal)
          
            let vieodata = comperssVideoList(url: videoUrl)
            
            
//            var movieData = Data()
//            do{
//                movieData = try Data.init(contentsOf: videoUrl , options: .alwaysMapped)
//            }catch{
//                print(error.localizedDescription)
//            }
//            self.videoProcess.isHidden = false
//            self.lblCvPercent.isHidden = false
//            //           movieData = try Data.init(contentsOf: file)
//            self.videoIma.borderColor = #colorLiteral(red: 0.04481492192, green: 0.284111917, blue: 0.5517202616, alpha: 1)
//            self.videoIma.borderWidth = 1
//            print(movieData)
//            self.videoProcess.setProgress(0.0, animated: true)
//            let dict = ["thumbnail":"data:image/jpeg;base64,"+convertImageToBase64String(img:self.videoIma.image!)]
//
//                        ApiClass().uploadVideoData(inputUrl: baseUrl+"upload-video", parameters: dict, imageName: "video", imageFile: movieData, header: userToken) { result in
//                            print(result)
//                            self.videoPer = false
//                            self.isVideoUploaindg = true
//                            self.videoProcess.isHidden = true
//                            self.lblCvPercent.isHidden = true
//                            self.UploadSuccessView.isHidden = false
//                            self.count = +1
//                            self.lblSucces.text = "Video uploaded successfully."
//
//                            let when = DispatchTime.now() + 2
//                            DispatchQueue.main.asyncAfter(deadline: when){
//                                self.UploadSuccessView.isHidden = true
//            //                    btnVideo.backgroundColor = UIColor(named: "white - Three")
//            //                    btnVideo.layer.borderWidth = 0
//                                self.videoIma.image = #imageLiteral(resourceName: "camera-1")
//                                self.videoIma.borderColor = nil
//                                self.videoIma.borderWidth = 0
//                                self.btndismiss.isUserInteractionEnabled = true
//                            }
//
//                            self.userProfile()
//                            //              self.ViewUploadVideo.isHidden = true
//                            //              self.btnVideo.setImage(UIImage(named: ""), for: .normal)
//                            //              self.videoCount += 1
//                        } processCompletion: { process in
//                            let value = process * 100
//                            self.lblCvPercent.isHidden = false
//                            self.videoProcess.isHidden = false
//                            self.lblCvPercent.text = "Uploading " + String(format: "%.0f", value) + "%"
//                            print("Upload Progress: \(process * 100))")
//                            //              self.ViewUploadVideo.isHidden = false
//                            self.videoProcess.setProgress(process, animated: true)
//                            self.videoPer = true
//                            self.btndismiss.isUserInteractionEnabled = false
//                        }
        default:
            print("Mismatched type: \(mediaType)")
        }
//
        picker.dismiss(animated: true, completion: nil)
    }
    
    func comperssVideoList(url:URL){
      
        FYVideoCompressor.shared.compressVideo(url, quality: .mediumQuality) { result in
                    switch result {
                    case .success(let compressedVideoURL):
                        print(compressedVideoURL)
                        let data = NSData(contentsOf: compressedVideoURL as URL)!
                       
                        
                        self.videoProcess.isHidden = false
                        self.lblCvPercent.isHidden = false
                        //           movieData = try Data.init(contentsOf: file)
                        self.videoIma.borderColor = #colorLiteral(red: 0.04481492192, green: 0.284111917, blue: 0.5517202616, alpha: 1)
                        self.videoIma.borderWidth = 1
//                        print(movieData)
                        self.videoProcess.setProgress(0.0, animated: true)
                        let dict = ["thumbnail":"data:image/jpeg;base64,"+self.convertImageToBase64String(img:self.videoIma.image!)]

                        ApiClass().uploadVideoData(inputUrl: baseUrl+"upload-video", parameters: dict, imageName: "video", imageFile: data as Data, header: self.userToken) { result in
                                        print(result)
                                        self.videoPer = false
                                        self.isVideoUploaindg = true
                                        self.videoProcess.isHidden = true
                                        self.lblCvPercent.isHidden = true
                                        self.UploadSuccessView.isHidden = false
                                        self.count = +1
                                        self.lblSucces.text = "Video uploaded successfully."

                                        let when = DispatchTime.now() + 2
                                        DispatchQueue.main.asyncAfter(deadline: when){
                                            self.UploadSuccessView.isHidden = true
                        //                    btnVideo.backgroundColor = UIColor(named: "white - Three")
                        //                    btnVideo.layer.borderWidth = 0
                                            self.videoIma.image = #imageLiteral(resourceName: "camera-1")
                                            self.videoIma.borderColor = nil
                                            self.videoIma.borderWidth = 0
                                            self.btndismiss.isUserInteractionEnabled = true
                                        }

                                        self.userProfile()
                                        //              self.ViewUploadVideo.isHidden = true
                                        //              self.btnVideo.setImage(UIImage(named: ""), for: .normal)
                                        //              self.videoCount += 1
                                    } processCompletion: { process in
                                        let value = process * 100
                                        self.lblCvPercent.isHidden = false
                                        self.videoProcess.isHidden = false
                                        self.lblCvPercent.text = "Uploading " + String(format: "%.0f", value) + "%"
                                        print("Upload Progress: \(process * 100))")
                                        //              self.ViewUploadVideo.isHidden = false
                                        self.videoProcess.setProgress(process, animated: true)
                                        self.videoPer = true
                                        self.btndismiss.isUserInteractionEnabled = false
                                    }
                        
                        
                        print("File size before compression: \(Double(data.length / 1048576)) mb")
                        print(compressedVideoURL)
                        
                        
                       
                    case .failure(let error):
                        print(error)
                    }
         }
    }
    
    
    
    func compressVideo(url: URL) {
        
        let destinationPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("compressed.mp4")
        try? FileManager.default.removeItem(at: destinationPath)
        
        let startingPoint = Date()
        
        
        let compression: Compression = videoCompressor.compressVideo(
            source: url,
            destination: destinationPath as URL,
            quality: .very_low,
            isMinBitRateEnabled: true,
            keepOriginalResolution: false,
            progressQueue: .main,
            progressHandler: { progress in
                // progress
                self.videoProcess.progress = Float(progress.fractionCompleted)
                
                self.lblCvPercent.text = "\(String(format: "%.0f", progress.fractionCompleted * 100))%"
                
            },
            completion: {[weak self] result in
                guard self != nil else { return }
                
                switch result {
                case .onSuccess(let path):
                    print(path)
                    let data = NSData(contentsOf: path as URL)!
                    print("File size before compression: \(Double(data.length / 1048576)) mb")
                    
                    
                    // success
                    
                case .onStart:
                    print("onStart")
                    // when compression starts
                    
                case .onFailure(let error):
                    print(error)
                    
                case .onCancelled:
                    print("onCancelled")
                    // if cancelled
                }
            }
        )
    }
    
    private func createVideoThumbnail(from url: URL) -> UIImage? {
        
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            
            
            return thumbnail
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
extension ProfileVC: UIDocumentMenuDelegate,UIDocumentPickerDelegate
{
    
    func pdfThumbnail(url: URL, width: CGFloat = 240) -> UIImage? {
        guard let data = try? Data(contentsOf: url),
              let page = PDFDocument(data: data)?.page(at: 0) else {
                  return nil
              }
        
        let pageSize = page.bounds(for: .bleedBox)
        let pdfScale = width / pageSize.width
        
        // Apply if you're displaying the thumbnail on screen
        let scale = UIScreen.main.nativeScale * pdfScale
        let screenSize = CGSize(width: pageSize.width * scale,
                                height: pageSize.height * scale)
        
        return page.thumbnail(of: screenSize, for: .bleedBox)
    }
    
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    func generatePdfThumbnail(of thumbnailSize: CGSize , for documentUrl: URL, atPage pageIndex: Int) -> UIImage? {
        let pdfDocument = PDFDocument(url: documentUrl)
        let pdfDocumentPage = pdfDocument?.page(at: pageIndex)
        return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.artBox)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        self.isCvUploaindg = false
        let thumbnailSize = CGSize(width: 120, height: 120)
        let urlstr = "\(myURL)"
//        let nesString = urlstr.replacingOccurrences(of: ".rtf", with: ".pdf")
       
        let thumbnail = generatePdfThumbnail(of: thumbnailSize, for: myURL, atPage: 0)
        
        self.cvImage.borderColor = #colorLiteral(red: 0.04481492192, green: 0.284111917, blue: 0.5517202616, alpha: 1)
        self.cvImage.borderWidth = 1
        
        if thumbnail == nil {
            self.cvImage.image = UIImage(named: "google-docs")
        }else {
            self.cvImage.image = thumbnail
        }
        
        //self.createVideoThumbnail(from: myURL)
        self.cvImage.contentMode = .scaleToFill
        self.videoProcess.isHidden = false
        self.lblCvPercent.isHidden = false
        
        let dict = ["cv_thumbnail":"data:image/jpeg;base64,"+convertImageToBase64String(img:self.cvImage.image!)]
        print("import result : \(myURL)")
        ApiClass().uploadPdfApi(inputUrl: baseUrl+"upload-cv", parameters: dict, pdfName: "cv", pdfFile: myURL, header: userToken) { result in
            print(result)
            self.cvPer = false
            self.isCvUploaindg = true
            self.videoProcess.isHidden = true
            self.lblCvPercent.isHidden = true
            self.UploadSuccessView.isHidden = false
            self.lblSucces.text = "CV uploaded successfully."
            
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                self.UploadSuccessView.isHidden = true
                self.cvImage.image = #imageLiteral(resourceName: "DoucumentRound")
                self.cvImage.borderColor = nil
                self.cvImage.borderWidth = 0
                self.btndismiss.isUserInteractionEnabled = true
            }
            self.userProfile()
            //             self.btnDoc.setImage(UIImage(named: ""), for: .normal)
        } processCompletion: { process in
            let value = process * 100
            self.lblCvPercent.text = String(format: "%.0f", value) + "%"
            print("Upload Progress: \(process * 100))")
            self.cvPer = true
            self.btndismiss.isUserInteractionEnabled = false
            //             self.ViewUploadResume.isHidden = false
            self.videoProcess.setProgress(process, animated: true)
        }
    }
    
    
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- WKNavigationDelegate
    //    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
    //    print(error.localizedDescription)
    //    }
    //     func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    //    print("Strat to load")
    //        }
    //func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    //    print("finish to load")
    //    }
    
}
//extension UIViewController{
//    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//
//
//        if (navigationController.viewControllers.count > 1)
//        {
//             self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//            navigationController.interactivePopGestureRecognizer?.isEnabled = true;
//        }
//        else
//        {
//             self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
//            navigationController.interactivePopGestureRecognizer?.isEnabled = false;
//        }
//    }
//}
