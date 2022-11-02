//
//  UploadVC.swift
//  Demo-push
//
//  Created by Arkamac1 on 07/01/22.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Alamofire
import WebKit
import TTGSnackbar
import PDFKit
import AVKit
var showingPopUp = false
//enum SubcriptionType:String {
//
//    case freeTrail = "FREE TRAIL",month = "MONTHLY",quarterly = "QUARTERLY",halfYearly = "HALF YEARLY",YEARLY = "YEARLY"
//}


protocol Subscription {
    func subcriptionPlanStatus(value:Int,title:String,subcriptionTitle:String)
}



class UploadVC: BaseViewController,Subscription, WKNavigationDelegate {
    
    func subcriptionPlanStatus(value: Int,title:String, subcriptionTitle: String) {
        if value == 1 {
            PopUpMain_View.isHidden = true
            PlanPopUpView.isHidden = true
            
            PopUp_View.isHidden = true
            subscriptionPopUPView.isHidden = true
//            self.text = title
            lblPlanName.text = title
            updateSuccessTitle(title:subcriptionTitle)
            
            let url = URL(string: cvUrlShow)
            if url != nil {
                cvView.load(URLRequest(url: url!))
            }
           
            
//            changeSubcriptionTitle(str: title)
        }
    }
    
    func updateSuccessTitle(title:String){
        
        if title == ""{
            self.lblSuccessTitle.text = "Your have " + "\(13)" + " days left for this subscription  plan To continue after" + "\(13)" + "days please upgrade your plan."
        }else if title == "month"{
            self.lblSuccessTitle.text = "Your have " + "\(29)" + " days left for this subscription  plan To continue after" + "\(29)" + " days please upgrade your plan."
        }else if title == "quarterly" {
            self.lblSuccessTitle.text = "Your have " + "\(89)" + " days left for this subscription  plan To continue after" + "\(89)" + " days please upgrade your plan."
        }else if title == "halfYearly" {
            self.lblSuccessTitle.text = "Your have " + "\(179)" + " days left for this subscription  plan To continue after" + "\(179)" + " days please upgrade your plan."
        }else if title == "YEARLY"{
            self.lblSuccessTitle.text = "Your have " + "\(364)" + " days left for this subscription  plan To continue after" + "\(364)" + " days please upgrade your plan."
        }
    }
//    func changeSubcriptionTitle(str:String){
//        lblsubTitle.text = "To Publish this Video or CV you have to take subscription for the same. We have also" + "\(text)" + "Subscription for 14 days."
//        lblsubTitle.font = UIFont(name: "Montserrat-Regular", size: 15.0)
//        lblsubTitle.textColor = #colorLiteral(red: 0.1686112285, green: 0.1686365306, blue: 0.1686026156, alpha: 1)
//
//        let attrStri = NSMutableAttributedString.init(string:lblsubTitle.text ?? "")
//        var nsRange = NSRange()
//
//        switch SubcriptionType(rawValue: str) {
//        case .freeTrail:
//            nsRange = NSString(string: lblsubTitle.text ?? "").range(of: SubcriptionType.freeTrail.rawValue , options: String.CompareOptions.caseInsensitive)
//        case .month:
//            nsRange = NSString(string: lblsubTitle.text ?? "").range(of: SubcriptionType.month.rawValue , options: String.CompareOptions.caseInsensitive)
//        case .quarterly:
//            nsRange = NSString(string: lblsubTitle.text ?? "").range(of: SubcriptionType.quarterly.rawValue , options: String.CompareOptions.caseInsensitive)
//        case .halfYearly:
//            nsRange = NSString(string: lblsubTitle.text ?? "").range(of: SubcriptionType.halfYearly.rawValue , options: String.CompareOptions.caseInsensitive)
//        case .YEARLY:
//            nsRange = NSString(string: lblsubTitle.text ?? "").range(of: SubcriptionType.YEARLY.rawValue , options: String.CompareOptions.caseInsensitive)
//        default:
//            break;
//        }
//
////            let nsRange = NSString(string: lblsubTitle.text ?? "").range(of: "FREE TRAIL", options: String.CompareOptions.caseInsensitive)
//
//        attrStri.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(named: "dark"), NSAttributedString.Key.font: UIFont.init(name: "Montserrat-SemiBold", size: 16.0) as Any], range: nsRange)
//
//        self.lblsubTitle.attributedText = attrStri
//    }
    
    
    @IBOutlet weak var cvProcess: UIProgressView!
    @IBOutlet weak var videoProcess: UIProgressView!
    @IBOutlet weak var instractionView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var PlanPopUpView: UIView!
    @IBOutlet weak var UploadVideo_View: UIView!
    @IBOutlet weak var Upload_Resume_View: UIView!
    @IBOutlet weak var PopUpMain_View: UIView!
    @IBOutlet weak var PopUp_View: UIView!
    @IBOutlet weak var videoDocView: UIView!
    @IBOutlet weak var ViewUploadVideo: UIView!
    @IBOutlet weak var ViewUploadResume: UIView!
    @IBOutlet weak var subscriptionPopUPView: UIView!
    @IBOutlet weak var Btn_Gotohome: UIButton!
    @IBOutlet weak var BtnPlan: UIButton!
    @IBOutlet weak var BtnOkay: UIButton!
    @IBOutlet weak var BtnGoToHome: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnCV: UIButton!
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var lblVideoPercent: UILabel!
    @IBOutlet weak var lblheader: UILabel!
    @IBOutlet weak var lblCvPercent: UILabel!
    @IBOutlet weak var lblsubTitle: UILabel!
    @IBOutlet weak var lblSuccessTitle:UILabel!
    @IBOutlet weak var videoImg: UIImageView!
    @IBOutlet weak var cvView: WKWebView!
    let pickerController = UIImagePickerController()
    var uploadViewModal = UploadViewModal()
    var cvUrl: String?
    var videoCount = 0
    var text = ""
    var counter = 30
    var iscvUpload = false
    var isVideoUpload = false
    var cvUrlShow = String()
    var uploadingVideo = false
    var uplodingCv = false
    private var demovideoUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.clipsToBounds = true
        alertView.layer.cornerRadius = 20
        alertView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMaxXMaxYCorner]
        
        
        BtnOkay.clipsToBounds = true
        BtnOkay.layer.cornerRadius = 45
        BtnOkay.layer.maskedCorners =  [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        if showingPopUp == true {
            showingPopUp = false
            self.instractionView.isHidden = false
        }else {
            self.instractionView.isHidden = true
        }
       
//        self.BtnPlan
        uploadViewModal.VC = self
        uploadViewModal.initialUIsetUp()
        
        lblsubTitle.text = "To Publish this Video or CV you have to take subscription for the same. We have also FREE TRAIL Subscription for 14 days."
        lblsubTitle.font = UIFont(name: "Montserrat-Regular", size: 15.0)
        lblsubTitle.textColor = #colorLiteral(red: 0.1686112285, green: 0.1686365306, blue: 0.1686026156, alpha: 1)
//        let text = "This is a colorful attributed string"
        
        let attrStri = NSMutableAttributedString.init(string:lblsubTitle.text ?? "")
            let nsRange = NSString(string: lblsubTitle.text ?? "").range(of: "FREE TRAIL", options: String.CompareOptions.caseInsensitive)
           
        attrStri.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(named: "dark"), NSAttributedString.Key.font: UIFont.init(name: "Montserrat-SemiBold", size: 16.0) as Any], range: nsRange)
           
        self.lblsubTitle.attributedText = attrStri
        btnUpload.setImage(UIImage(named: "Publish"), for: .normal)
        
        let userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
        ApiClass().demoVideoApi(view: self.view, inputUrl: baseUrl + "sample-url", parameters: [:], header: userToken) { result in
            print(result)
            let dict = result as? JsonDict
            let url = dict?["data"] as? String ?? ""
            self.demovideoUrl = url
        }
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    @IBAction func btnOkay(_ sender: UIButton) {
        self.instractionView.isHidden = true
    }
    
    @IBAction func btnVideoPlay(_ sender: UIButton) {
//      guard self.demovideoUrl != "" else {
//            let snackbar = TTGSnackbar(message: "No video found.", duration: .short)
//            snackbar.show()
//            return
//        }
//          let videoURL: NSURL = NSURL(string: demovideoUrl)!
//        let player = AVPlayer(url: videoURL as URL)
//            let playerViewController = AVPlayerViewController()
//            playerViewController.player = player
//            self.present(playerViewController, animated: true) {
//                playerViewController.player!.play()
//            }
        
        guard let videoURL = URL(string: demovideoUrl) else {
            let snackbar = TTGSnackbar(message: "No video found.", duration: .short)
            snackbar.show()
           
            return
        }
        
        let videoAsset = AVURLAsset(url: videoURL as URL)
               let item = AVPlayerItem(asset: videoAsset)
               let player = AVPlayer(playerItem: item)
               let controller = AVPlayerViewController()
               controller.player = player

               present(controller, animated: true) {
                   player.play()
               }
        
        
    }
    
    @IBAction func BtndidTapBack(_ sender: UIButton) {
      
        if uplodingCv == true || uploadingVideo == true {
            self.appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func Btn_UploadVideo(_ sender: UIButton) {
        
        if self.iscvUpload == true {
            let snackbar = TTGSnackbar(message: "Please wait while uploding CV.", duration: .short)
            snackbar.show()
        }else {
            
            if self.videoCount == 1 {
                let snackbar = TTGSnackbar(message: "At register time you can upload  maximum one video.", duration: .short)
                snackbar.show()
            }else {
                
        //        * Part 1: Select the origin of media source
        //        Either one of the belows:
        //        1. .photoLibrary     -> Go to album selection page
        //        2. .savedPhotosAlbum -> Go to Moments directly
        //        */
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
        }
        }
    }
    
    @IBAction func Btn_UploadResume(_ sender: UIButton) {
        
        if  self.isVideoUpload == true {
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
        
        
//        ViewUploadResume.isHidden = false
//        // PopUpMain_View.isHidden = false
//        PopUpMain_View.isHidden = false
//        videoDocView.isHidden = false
//        subscriptionPopUPView.isHidden = true
    }
    
    @IBAction func btn_HidePopUp(_ sender: UIButton) {
        PopUpMain_View.isHidden = false
        videoDocView.isHidden = true
        PlanPopUpView.isHidden = false
        subscriptionPopUPView.isHidden = true
    }
    
    @IBAction func didTapPlan(_ sender: UIButton) {
        PopUpMain_View.isHidden = true
        PlanPopUpView.isHidden = true
    }
    
    
    //MARK: Cancel Uploding popup
    
    @IBAction func CancelUploadVideo(_ sender: UIButton) {
        stopTheDamnRequests()
        ViewUploadVideo.isHidden = true
    }
    @IBAction func CancelUploadResume(_ sender: UIButton) {
        stopTheDamnRequests()
        ViewUploadResume.isHidden = true
    }
    
    func startTimer(){
      

    }
    @IBAction func didTapUpload(_ sender: UIButton) {
//        PopUpMain_View.isHidden = false
        
        if self.uplodingCv == true || uploadingVideo == true {
            
            if (cvUrl != nil) && (videoImg.image != nil) {
                startTimer()
                self.lblheader.text = "Video and CV is uploaded."
                
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when){
                    self.PopUpMain_View.isHidden = false
                    self.videoDocView.isHidden = true
                    self.PlanPopUpView.isHidden = false
                }
                
                self.PopUpMain_View.isHidden = false
                self.videoDocView.isHidden = false
            }else if cvUrl != nil && self.uplodingCv == true {
                startTimer()
                self.lblheader.text = "CV is uploaded."
                
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when){
                    self.PopUpMain_View.isHidden = false
                    self.videoDocView.isHidden = true
                    self.PlanPopUpView.isHidden = false
                }
                
                self.PopUpMain_View.isHidden = false
                self.videoDocView.isHidden = false
                self.subscriptionPopUPView.isHidden = true
            }else if videoImg.image != nil && uploadingVideo == true {
             
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when){
                    self.PopUpMain_View.isHidden = false
                    self.videoDocView.isHidden = true
                    self.PlanPopUpView.isHidden = false
                }
                
                self.lblheader.text = "Video is uploaded."
                self.PopUpMain_View.isHidden = false
                self.videoDocView.isHidden = false
            }else {
               
                let snackbar = TTGSnackbar(message: "Please select video or CV.", duration: .short)
                snackbar.show()
            }
        }
        
    }
    @IBAction func didTapGoToPlan(_ sender: UIButton) {
        
        PopUpMain_View.isHidden = true
        PlanPopUpView.isHidden = true
        
        let storyboard = UIStoryboard(name: "Subscriptions", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FreeTrialVC") as! FreeTrialVC
        vc.isRegister = true
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
      
    }
    
    @IBAction func didTapGoToHome(_ sender: UIButton) {
        appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
    }
    func stopTheDamnRequests(){
        
        if #available(iOS 9.0, *) {
            Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
                tasks.forEach{ $0.cancel()
                    if ($0.originalRequest?.url?.absoluteString == baseUrl+"upload-video")
                    {

                        $0.cancel()
                    }
                    
                }
            }
        } else {
           
            Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
                
                sessionDataTask.forEach
                {
                    if ($0.originalRequest?.url?.absoluteString == baseUrl+"upload-video")
                       
                    {
                 
                        $0.cancel()
                       
                    }
                    if ($0.originalRequest?.url?.absoluteString == baseUrl+"upload-cv")
                    {
                        $0.cancel()
                    }
                }
            }
        }
        self.btnCV.isUserInteractionEnabled = true
        self.btnVideo.isUserInteractionEnabled = true
    }
}
extension UploadVC: UIDocumentMenuDelegate,UIDocumentPickerDelegate
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
        self.iscvUpload = true
        present(documentPicker, animated: true, completion: nil)
    }

     func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
         let image1 = UIImageView()
         cvView.navigationDelegate = self
         let url = URL(string: myURL.absoluteString)
         cvUrlShow = myURL.absoluteString
         cvView.load(URLRequest(url: url!))
         cvUrl = myURL.absoluteString
         let pdfImage = pdfThumbnail(url:url!, width: 120)
         print("import result : \(myURL)")
         
         if pdfImage == nil {
             image1.image = UIImage(named: "google-docs")
         }else {
             image1.image = pdfImage
         }
         
         let dict = ["cv_thumbnail":"data:image/jpeg;base64,"+convertImageToBase64String(img:image1.image!)]
         
         ApiClass().uploadPdfApi(inputUrl: baseUrl+"upload-cv", parameters: dict, pdfName: "cv", pdfFile: myURL, header: userToken) { result in
             print(result)
             let dict = result as? JsonDict
             
             if dict != nil
             {
                 self.uplodingCv = true
                 self.btnVideo.isUserInteractionEnabled = true
                 self.btnUpload.setImage(UIImage(named: "UPLOAD-1"), for: .normal)
                 self.ViewUploadResume.isHidden = true
                 self.btnCV.setImage(UIImage(named: ""), for: .normal)
                 self.iscvUpload = false
             }else{

                 
                 if let clearURL = URL(string: "about:blank") {
                     self.cvView.load(URLRequest(url: clearURL))
                 }
                 self.uplodingCv = false
                 self.ViewUploadResume.isHidden = true
                 self.btnCV.setImage(UIImage(named: "document"), for: .normal)
                 self.iscvUpload = false
             }
             
            
         } processCompletion: { process in
//             DispatchQueue.main.async {
             self.uplodingCv = false
                 self.iscvUpload = true
                 self.lblVideoPercent.text = ""
                 let value = process * 100
                 self.btnVideo.isUserInteractionEnabled = false
                 self.lblVideoPercent.text = String(format: "%.0f", value) + "%"
                 print("Upload Progress: \(process * 100))")
                 self.ViewUploadResume.isHidden = false
                 self.cvProcess.setProgress(process, animated: true)
//             }
         }
    }
       
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        self.iscvUpload = false
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- WKNavigationDelegate
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
    print(error.localizedDescription)
    }
     func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    print("Strat to load")
        }
func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    print("finish to load")
    }
    
}
extension UploadVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
         
        let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as! URL
          print("Selected media is video",videoUrl)
          self.videoImg.image = self.createVideoThumbnail(from: videoUrl)
          var movieData = Data()
          do{
              movieData = try Data.init(contentsOf: videoUrl , options: .alwaysMapped)
          }catch{
              print(error.localizedDescription)
          }
          self.videoProcess.setProgress(0.0, animated: true)
          
          let dict = ["thumbnail":"data:image/jpeg;base64,"+convertImageToBase64String(img:self.videoImg.image!)]
          
          ApiClass().uploadVideoData(inputUrl: baseUrl+"upload-video", parameters: dict, imageName: "video", imageFile: movieData, header: userToken) { result in
              print(result)
              let data = result as? JsonDict
              if data != nil {
                  self.btnUpload.setImage(UIImage(named: "UPLOAD-1"), for: .normal)
                  self.isVideoUpload = false
                  self.ViewUploadVideo.isHidden = true
                  self.btnVideo.setImage(UIImage(named: ""), for: .normal)
                  self.videoCount += 1
                  self.uploadingVideo = true
                  self.btnCV.isUserInteractionEnabled = true
              }else {
                  DispatchQueue.main.async{
                      self.isVideoUpload = false
                      self.videoImg.image = UIImage(named: "")
                      self.uploadingVideo = false
                        self.ViewUploadVideo.isHidden = true
                      self.btnVideo.setImage(UIImage(named: "Camera"), for: .normal)
//                            self.videoCount += 1
                      self.btnCV.isUserInteractionEnabled = true
                    
                  }
              }
          } processCompletion: { process in
              let value = process * 100
//              self.btnCV.isUserInteractionEnabled = false
              self.lblVideoPercent.text = String(format: "%.0f", value) + "%"
              print("Upload Progress: \(process * 100))")
              self.ViewUploadVideo.isHidden = false
              self.uploadingVideo = false
              self.isVideoUpload = true
              self.videoProcess.setProgress(process, animated: true)
          }
      default:
        print("Mismatched type: \(mediaType)")
      }

      picker.dismiss(animated: true, completion: nil)
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
extension UIView {
    
    func roundCorner(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
    }
    
}

extension WKWebView {
    
    func load(_ urlString: String) {
        
        //print("Blog Extension", #function)
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
extension NSMutableAttributedString {
    
    class func getAttributedString(fromString string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string)
    }
    
    func apply(attribute: [NSAttributedString.Key: Any], subString: String)  {
        if let range = self.string.range(of: subString) {
            self.apply(attribute: attribute, onRange: NSRange(range, in: self.string))
        }
    }
    
    func apply(attribute: [NSAttributedString.Key: Any], onRange range: NSRange) {
        if range.location != NSNotFound {
            self.setAttributes(attribute, range: range)
        }
    }
}
