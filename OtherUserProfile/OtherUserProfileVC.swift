//
//  OtherUserProfileVC.swift
//  JabyJob
//
//  Created by DMG swift on 11/03/22.
//
//<calculated when request is sent>
import UIKit
import SDWebImage
import MessageUI
class OtherUserProfileVC: BaseViewController {
  
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnDoc: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var colletionMy: UICollectionView!
    private var dataUser = [OtherUserInfoModal]()
    private var countryName = [String]()
    private var skills = [String]()
    private var isDocrOrVideo = false
    let comefrom = "guest"
    var cvPath = String()
    var id = Int()
    var nextNavigationController = UINavigationController()
    var otherUserId = Int()
    var pdfurl = ""
    var guestuserID = Int()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOtherUserInfoApi()
        // Do any additional setup after loading the view.
    }
    
    
   private func getOtherUserInfoApi(){
    let userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
    let userid = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
          print(userid)
       
       let param = ["id":id,"login_user_id":guestuserID] as JsonDict
       ApiClass().getOtherUserInfo(view: self.view, inputUrl: baseUrl+"another-profile", parameters: param, header: userToken) { result
           in
//           let data = result as? OtherUserInfoModal
          // let guestUser = self.dataUser[0]
           self.dataUser.append(result as! OtherUserInfoModal)
           print("the data is ajeet", self.dataUser)
           self.lblEmail.text = "@"+(self.dataUser[0].data?.user?.username ?? "")
          // self.otherUserId = self.dataUser[0].data?.user?.id ?? 0
           
           _ = self.dataUser[0].country?.compactMap({ list in
               self.countryName.append(list.country?.name ?? "")
           })
         
           self.lblCountry.text = self.countryName.map{String($0)}.joined(separator: ",")
           
           _ = self.dataUser[0].skill?.compactMap({ list in
               self.skills.append(list.skill?.name ?? "")
           })
           self.lblSubCategory.text = self.skills.map{String($0)}.joined(separator: ",")
           self.lblCategory.text = self.dataUser[0].data?.user?.category?.title ?? ""

           self.cvPath = self.dataUser[0].data?.user?.cvThumbnail ?? ""
           self.pdfurl = self.dataUser[0].data?.user?.cv ?? ""
           self.colletionMy.reloadData()
           print(result)
       }
   }
    
    
    
    @IBAction func btnDidTapBack(_ sender: UIButton) {
        let vc = HomeTabBarVC()
//#MARK: ajeet only put condition if else this condition is use to when we come from guest user and register user
        if self.userToken == "" {
            self.navigationController?.popViewController(animated: false)

        }else{
            self.dismiss(animated: true)
        }
                    vc.viewWillAppear(true)
            
            NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: true)
            
        
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didtapWhatsapp(_ sender:UIButton){
        let phone = self.dataUser[0].data?.user?.phone

        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(String(describing: phone))")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        }
        
        
//        let urlWhats = "https://api.whatsapp.com/send?phone=\(String(describing: phone))"
//            //"https://wa.me/\(phone)?text=I%20would%20like%20to%20book%20an%20appointment%20with%20you"
//                if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
//                    print(urlString)
//                    if let whatsappURL = URL(string: urlString) {
//                        if UIApplication.shared.canOpenURL(whatsappURL) {
//                            UIApplication.shared.openURL(whatsappURL)
//                        }
//                        else {
//                            print("Install Whatsapp")
//                        }
//                    }
//                }
    }
    @IBAction func didTapChat(_ sender:UIButton){
        
        let storyboard = UIStoryboard(name: "ChatVC", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.modalPresentationStyle = .overFullScreen
        vc.roomId = "\(id)-" + "\(otherUserId)"
        vc.senderId = "\(otherUserId)"
        vc.reciverId = "\(id)"
        self.present(vc, animated: true, completion: nil)
       
    }
    @IBAction func didtapEmail(_ sender:UIButton){
        self.sendMail()
    }
    @IBAction func didtapCall(_ sender:UIButton){
        let call = dataUser[0].data?.user?.phone ?? 0
        if let phoneCallURL = URL(string: "telprompt://\(call)") {

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
    

    @IBAction func didtapVideo(_ sender:UIButton){
        isDocrOrVideo = false
        btnVideo.backgroundColor = UIColor(named: "white - Three")
        btnVideo.layer.borderWidth = 0
        btnDoc.backgroundColor = .white
        btnDoc.layer.borderWidth = 0.7
        btnDoc.borderColor = UIColor(named: "white - Three")
        colletionMy.reloadData()
    }
    
    @IBAction func didtapDoc(_ sender:UIButton){
        isDocrOrVideo = true
        btnDoc.backgroundColor = UIColor(named: "white - Three")
        btnVideo.backgroundColor = .white
        btnVideo.layer.borderWidth = 0.7
        btnDoc.layer.borderWidth = 0
        btnVideo.borderColor = UIColor(named: "white - Three")
        colletionMy.reloadData()
    }
}

extension OtherUserProfileVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @objc func didTapPlayVideo(_ sender:UIButton){
        
        
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VideoListOtherUser") as! VideoListOtherUser
        vc.videoRowData = self.dataUser

        vc.idUser = id
        vc.videoTag = sender.tag
        vc.isFromSave = false
        vc.isVideo = true
        vc.modalPresentationStyle = .overFullScreen
//        vc.idUser = id
        self.present(vc, animated: true, completion: nil)
//        self.nextNavigationController.pushViewController(vc, animated: true)
        
        
//        let data = self.viedosData[sender.tag] as? JsonDict
//
//
//        let videoURL = URL(string: data?["name"] as? String ?? "")
//        let player = AVPlayer(url: videoURL!)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.present(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        if isDocrOrVideo == false {
            if self.dataUser.count > 0 {
                self.colletionMy.setEmptyMessage("")
                return self.dataUser[0].video?.count ?? 0
            }else {
                self.colletionMy.setEmptyMessage("No data found")
                return 0
            }
          
        }else {
            
            if self.cvPath != "" {
                self.colletionMy.setEmptyMessage("")
                return 1
            }else {
                self.colletionMy.setEmptyMessage("No data found")
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colletionMy.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! ProfileCollCell
        cell.btnCVDelete.isHidden = true
        cell.btnDelete.isHidden = true
        if self.isDocrOrVideo == false{
            
            let data = self.dataUser[0].video?[indexPath.row]  //self.viedosData[indexPath.row] as? JsonDict
            cell.img_user.sd_setImage(with: URL(string:thumbnailbaseUrl+(data?.thumbnail ?? "")), placeholderImage: UIImage(named: "file-video-icon-256"), options: .refreshCached) { (image, error, cacheType, url) in
                //                    self.userImg.image = image
            }
            cell.btn_play.addTarget(self, action: #selector(self.didTapPlayVideo(_:)), for: .touchUpInside)
            cell.btn_play.tag = indexPath.row
            
        }else {
            cell.img_user.sd_setImage(with: URL(string:self.cvPath), placeholderImage: UIImage(named: "placeholder-thumbnail-document"), options: .refreshCached) { (image, error, cacheType, url) in
                //                    self.userImg.image = image
            }
        
            
            cell.btn_play.isHidden = true
            
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isDocrOrVideo == true{
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PdfViewerVC") as! PdfViewerVC
            vc.pdfViewUrl = self.pdfurl
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        return CGSize(width: collectionView.frame.width/3.03, height: 125)
        
        //return CGSize(width:125,height:125)
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
    
    
}


extension OtherUserProfileVC:MFMailComposeViewControllerDelegate, UINavigationControllerDelegate{
    
    func sendMail()
    {
        if MFMailComposeViewController.canSendMail()
        {
            let message:String  = "Changes in mail composer ios 11"
            let composePicker = MFMailComposeViewController()
            composePicker.mailComposeDelegate = self
            composePicker.delegate = self
            composePicker.setToRecipients([self.lblEmail.text!])
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
