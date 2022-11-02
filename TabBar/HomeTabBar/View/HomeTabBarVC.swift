//
//  HomeTabBarVC.swift
//  JabyJob
//
//  Created by DMG swift on 06/01/22.
//

import UIKit
import iOSDropDown
import TTGSnackbar
import AVFoundation
import SDWebImage
import AVKit
import AVFoundation
import GSPlayer
import FirebaseDynamicLinks

var isFromDeepLinking = false
var isshare = 0
var shareduserId = 0
var shared_videoID = 0


class HomeTabBarVC: BaseViewController {
    @IBOutlet weak var bgView: UIView!
    let layout = UICollectionViewFlowLayout()
    @IBOutlet weak var videoColl: UICollectionView!
    //    @IBOutlet weak var dropDown : DropDown!
    //    @IBOutlet weak var catDropDown : DropDown!
    var isDropDown = false
    var screenWidth: CGFloat!
    var videoRowData = [HomeVideoModal]()
    var dataSource:[String] = []
    private var cateid = Int()
    private var cateArr = [String]()
    private var categoryData = [[String:Any]]()
    private var OldCategory = String()
    private var saveIndex = IndexPath()
    private var isSave = false
    private var refreshControl = UIRefreshControl()
    var isPlay = true
    var vieoUrls = [URL]()
    let userToken1 = ""
    let comefrom = "guest"
    private var page = 1
    private var isWating = false
    private var moreData = [HomeVideoModal]()
    private var isLoad = false
    private var totalPage = 0
    private var catId = Int()
    private var isFromSearch = false
    private var noDataFound = false
    private var isOnOtherClass = false
    
    var guestUserID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.videoRowData.removeAll()
        self.videoList()
        
        videoColl.delegate = self
        videoColl.dataSource = self
        self.videoColl.isPagingEnabled = true
        self.videoColl.contentMode = .scaleAspectFill
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(StopforgroundNotification(notification:)), name: Notification.Name("stopePlayer"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateVidoList(videoListUpdate:)), name: Notification.Name("videoList"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(filterNotification(notification:)), name: Notification.Name("CategoryNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deeplInkingApiCall(deeplinkingNotification:)), name: Notification.Name("deepLinking"), object: nil)
        
        
        if UserDefaults.standard.value(forKey: "UserLogin") as? Int ?? 0 == 1 {
            let deviceToken =  UserDefaults.standard.value(forKey: "FCMToken") as? String ?? ""
        print("this is device token",deviceToken)
            updateUserToken(deviceToken)
            
        }
        if UserDefaultData.value(forKey: "userToken") as? String ?? "" != "" {
            userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//
//        if isOnOtherClass == false{
//            self.videoRowData.removeAll()
//            self.videoList()
//        }
//
//    }
    
    @objc func deeplInkingApiCall(deeplinkingNotification: Notification) {
        self.videoList()
        //        print(deeplinkingNotification.object as? [String:Any])
    }
    
    
    func updateUserToken(_ deviceToken: String){
        var dict = [String:Any]()
        let userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
        
        if UserDefaults.standard.value(forKey: "UserLogin") as? Int ?? 0 == 1 {
            let uuid =  UUID().uuidString
            
            dict = ["device_token":deviceToken,
                    "device_type": 2,
                    "device_id":uuid] as JsonDict
            
            ApiClass().updateTokenApi(view: self.view, inputUrl: baseUrl+"save-device-token", parameters: dict, header:userToken) { result in
                print(result)
            }
        }
    }
    
    @objc func updateVidoList(videoListUpdate: Notification) {
        isPlay = true
        page = 1
        self.videoRowData.removeAll()
        self.videoList()
        
    }
    
    @objc func StopforgroundNotification(notification: Notification) {
        
        if notification.object as? Bool == false {
            isPlay = false
            check()
            isOnOtherClass = true
        }else {
            isOnOtherClass = false
            isPlay = true
            check()
        }
    }
    
    @objc func filterNotification(notification: Notification) {
        print(notification)
        let dict = notification.userInfo as? JsonDict
        let catData = dict?["CategoryData"] as? JsonDict
        let roleid = dict?["role"] as? Int ?? 0
        print(catData?["id"] as? Int ?? 0)
        catId = catData?["id"] as? Int ?? 0
        isFromSearch = true
        isPlay = true
        page = 1
        //        var param = JsonDict()
        //        if UserDefaults.standard.value(forKey: "UserLogin") as? Int ?? 0 == 1 {
        //
        UserDefaults.standard.set(roleid, forKey: "role_id")
        self.videoList()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        check()
    }
    
    
    @objc private func didPullToRefresh(_ sender: Any) {
        // Do you your api calls in here, and then asynchronously remember to stop the
        // refreshing when you've got a result (either positive or negative)
        videoList()
        refreshControl.endRefreshing()
    }
    
    deinit {
        print("Remove")
    }
    
//    func getUserDetails(){
//        let userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
//        if UserDefaults.standard.value(forKey: "UserLogin") as? Int ?? 0 == 1 {
//            ApiClass().getUserProfile(view: self.view, inputUrl:  baseUrl+"profile", parameters: [:], header: userToken) { result in
//                let dict = result as? [String:Any]
//                if dict?["status"] as? Int ?? 0 == 1 {
//                    self.clearUserData()
//                    UserDefaults.standard.set(1, forKey: "UserLogin")
//                    UserDefaults.standard.set(dict!, forKey: "userData")
//                    self.videoList()
//                }
//            }
//        }
//    }
    
    func videoList(){
        var param = JsonDict()
        
        if UserDefaults.standard.value(forKey: "UserLogin") as? Int ?? 0 == 1 {
            let role_id = UserDefaults.standard.value(forKey: "role_id") as? Int ?? 0
            let userid = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
            param = ["role_id":role_id,"page":page,"user_id":userid,"category":catId,"is_share":isshare,"shared_userId":shareduserId,"shared_videoID":shared_videoID]
            
        }else {
            param = ["page":page,"category":catId,"is_share":isshare,"shared_userId":shareduserId,"shared_videoID":shared_videoID,"role_id":0,"user_id":0]
        }
        print("JabyJobParam",param)
        //        isFromDeepLinking = false
        ApiClass().videoListApi(view: self.view, inputUrl: baseUrl+"get-video-list", parameters: param, header: userToken1) { result in
            print("dineshVideoList",result)
            let data = result as? HomeVideoModal
            self.totalPage = data?.lastPage ?? 0
            self.noDataFound = true
            if self.isFromSearch == true {
                self.isFromSearch = false
                self.isLoad = false
                if data?.data?.count ?? 0 > 0 {
                    self.videoRowData.removeAll()
                }else {
                    let alert = UIAlertController(title: "Alert", message: "No data found", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
            
            if data?.data?.count ?? 0 > 0 {
                
                
                if isFromDeepLinking == true {
                    isFromDeepLinking = false
                    self.videoRowData.removeAll()
                }
                
                if self.isLoad == true {
                    self.isLoad = false
                    
                    self.moreData.removeAll()
                    // self.videoRowData.append(result as! HomeVideoModal)
                    self.moreData.append(result as! HomeVideoModal)
                    for i in 0..<(self.moreData[0].data?.count ?? 0){
                        self.videoRowData[0].data?.append(self.moreData[0].data![i])
                    }
                    
                    for i in 0..<(self.videoRowData.count){
                        let url = URL(string:  self.videoRowData[0].data?[i].video ?? "")
                        self.vieoUrls.append(url!)
                    }
                    
                }else {
                    self.videoRowData.append(result as! HomeVideoModal)
                    for i in 0..<(self.videoRowData.count){
                        let url = URL(string:  self.videoRowData[0].data?[i].video ?? "")
                        self.vieoUrls.append(url!)
                    }
                }
            }
            DispatchQueue.main.async {
                self.videoColl.reloadData()
            }
           
        }
    }
}

extension HomeTabBarVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @objc func didTapSave(_ sender:UIButton){
        let dict = ["video_id":self.videoRowData[0].data?[sender.tag].videoID ?? 0]
        if self.videoRowData[0].data?[sender.tag].saveVideoStatus == true {
            ApiClass().deleteVideoApi(view: self.view, inputUrl: baseUrl+"remove-saved-video", parameters: dict, header: self.userToken) { result in
                print(result)
                
                let dict = result as? JsonDict
                if dict?["status"] as? Int == 1 {
                    //                                self.userProfile()
                    
                    self.videoRowData[0].data?[sender.tag].saveVideoStatus = false
                    let indexPath = IndexPath(item: sender.tag, section: 0)
                    self.videoColl.reloadItems(at: [indexPath])
                }
                let snackbar = TTGSnackbar(message: dict?["message"] as? String ?? "", duration: .short)
                snackbar.show()
                //                self.videoList()
            }
        }else {
            if self.userToken == "" {
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "UserTypeVC")
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)
            }else {
                ApiClass().saveVideoApi(view: self.view, inputUrl: baseUrl+"save-video", parameters: dict, header: self.userToken) { result in
                    print(result)
                    let dict = result as? JsonDict
                    let snackbar = TTGSnackbar(message: dict?["message"] as? String ?? "", duration: .short)
                    snackbar.show()
                    self.videoRowData[0].data?[sender.tag].saveVideoStatus = true
                    let indexPath = IndexPath(item: sender.tag, section: 0)
                    
                    
                    self.videoColl.reloadItems(at: [indexPath])
                    self.saveIndex = indexPath
                    
                    self.isSave = true
                    //                    self.videoList()
                    
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.videoRowData.count > 0 {
            self.videoColl.setEmptyMessage("")
            self.videoColl.restore()
            return self.videoRowData[0].data?.count ?? 0
        }else {
            
            if noDataFound == true {
                self.videoColl.setEmptyMessage("No data found")
            }
            return 0
        }
    }
    @objc func didTapRepoert(_ sender: UITapGestureRecognizer){
        
        if self.userToken == "" {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UserTypeVC")
            
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            guard let getTag = sender.view?.tag else { return }
            let storyboard = UIStoryboard(name: "Report", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
            vc.videoId = self.videoRowData[0].data?[getTag].videoID ?? 0
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: false) {
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.isDropDown == false {
                self.videoColl.reloadData()
                self.isDropDown = true
            }
            
        }
    }
    
    //    func stopPlayer(_ cell:VideoCell? = nil){
    //        cell?.player.stop()
    //    }
    
    
    @objc func didTapUserName(_ sender:UIButton){
        
        ///for the stope video palyer when user tap on @UserName
        let userid = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
        
        if userid == 0 {
            getGuestUerId()
        }
        
        isPlay = false
        if self.userToken == "" {

            print(userToken)
//            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "UserTypeVC")
// #MARK: ajeet add for jump user name to user profile using navigaton and goto direct to user profile

            let storyboard = UIStoryboard(name: "OtherProfile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
            vc.guestuserID = guestUserID
            vc.id = self.videoRowData[0].data?[sender.tag].userID ?? 0
             
            self.navigationController?.pushViewController(vc, animated: true)

            //MARK: ajeet comment modelpresentionstyle 
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: false, completion: nil)
//
}else {
            let userid = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
            if self.videoRowData[0].data?[sender.tag].userID ?? 0 != userid {
                let storyboard = UIStoryboard(name: "OtherProfile", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
                vc.otherUserId = userid
                
                print(userid)
                vc.id = self.videoRowData[0].data?[sender.tag].userID ?? 0
                vc.nextNavigationController = self.navigationController!
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true) {
                    NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: false)
                }
                
            }
            
        }
//                self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func getGuestUerId(){
        let uuid =  UIDevice.current.identifierForVendor?.uuidString
        let deviceToken =  UserDefaults.standard.value(forKey: "FCMToken") as? String ?? ""
        
        let params = ["device_token":deviceToken,"device_type":2,"device_id":uuid!] as JsonDict
        
        ApiClass().getGuestUserId(view: self.view, inputUrl: baseUrl+"get-user-id", parameters: params, header: "") { result in
            print(result)
            let dict = result as? JsonDict
//            self.guestUser = true
            
            self.guestUserID = dict?["userId"] as? Int ?? 0

        }
    }
    
    func getFormattedDate(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date1  = dateFormatterGet.date(from: string)
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM,yyyy"
        
        let date = dateFormatterPrint.string(from: date1!)
        print(date)
        return date
        //        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        //        return dateFormatterPrint.string(from: date!);
    }
    
    @objc func didTapShare(_ sender:UIButton){
        let videoId = self.videoRowData[0].data?[sender.tag].videoID ?? 0
        
        guard let videoNmae = self.videoRowData[0].data?[sender.tag].video else { return }
        let userId = self.videoRowData[0].data?[sender.tag].userID
        guard let link = URL(string: "https://www.jabyjob.com/?video="+videoNmae+"/"+"&video_Id="+"\(videoId)"+"&is_shared=1"+"&shared_UserID="+"\(userId ?? 0)"+"&is_android=1") else { return }
        //        let dynamicLinksDomainURIPrefix = "https://jabyjob.page.link"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: "https://jabyjob.page.link")
        if let bundelId = Bundle.main.bundleIdentifier{
            linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: bundelId)
        }
        
        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.jabyjob")
        
        guard let longDynamicLink = linkBuilder?.url else { return }
        print("The long URL is: \(longDynamicLink)")
        
        
        guard let shareLink = DynamicLinkComponents.init(link: longDynamicLink, domainURIPrefix: "https://jabyjob.page.link") else {
            print("Could't create FDL Compoents")
            return
        }
        
        //        if let bundelId = Bundle.main.bundleIdentifier{
        //            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: bundelId)
        //        }
        shareLink.iOSParameters?.appStoreID = "962194608"
        //        shareLink.androidParameters = DynamicLinkAndroidParameters(packageName: "com.jabyjob")
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = self.videoRowData[0].data?[sender.tag].username ?? ""
        shareLink.socialMetaTagParameters?.descriptionText = "safk;hsdjklbchasbjkhgsuabdhkcjbasdkhjcgjkasdbcjhgasdhjbcasdlgcabsdc"
        shareLink.socialMetaTagParameters?.imageURL =  URL(string: self.videoRowData[0].data?[sender.tag].videoThumbnail ?? "")
        //        guard let finalUrl = shareLink.url else {
        //            return
        //        }
        //        print("the long dynamic link is \(finalUrl.absoluteURL)")
        //        self.showShareSheet(url: finalUrl)
        shareLink.shorten { url, warning, error in
            if let error = error {
                print("dam error\(error)")
                return
            }
            if let warnings = warning{
                print("FDL warning\(warnings)")
            }
            guard let url = url else {
                return
            }
            print("I have a short URL to share! \(url.absoluteURL)")
            self.showShareSheet(url: url)
        }
    }
    
    func showShareSheet(url:URL) {
        let promoText = "asfasdfasdfasdasdf"
        let activictyVC = UIActivityViewController(activityItems: [url,promoText], applicationActivities: nil)
        present(activictyVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = videoColl.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
        cell.lblUserName.text = "@"+(self.videoRowData[0].data?[indexPath.row].username ?? "")
        let skills = self.videoRowData[0].data?[indexPath.row].skills.map{String($0)}
        cell.lblSkills.text = skills?.joined(separator: ",")
        cell.btnSave.addTarget(self, action: #selector(didTapSave(_:)), for: .touchUpInside)
        cell.btnSave.tag = indexPath.row
        
        let reportTap = UITapGestureRecognizer(target: self, action: #selector(didTapRepoert(_:)))
        cell.btnUserTap.addTarget(self, action: #selector(didTapUserName(_:)), for: .touchUpInside)
        cell.btnUserTap.tag = indexPath.row
        cell.reportView.addGestureRecognizer(reportTap)
        cell.reportView.tag = indexPath.row
        
//        cell.blurImg.isHidden = false
     
//        DispatchQueue.global().sync() { [weak self] in
//            let url = URL(string:self?.videoRowData[0].data?[indexPath.row].videoThumbnail ?? "")
//                   let data = try! Data(contentsOf: url!)
//              cell.bgImg.image = UIImage(data: data)
//               }
//        cell.bgImg.downloaded(from:videoRowData[0].data?[indexPath.row].videoThumbnail ?? "" )
        
        cell.set(url:self.videoRowData[0].data?[indexPath.row].video ?? "")
        
      
        cell.btnShare.tag = indexPath.row
        cell.btnShare.addTarget(self, action: #selector(didTapShare(_:)), for: .touchUpInside)
        if self.videoRowData[0].data?[indexPath.row].saveVideoStatus == false {
            cell.saveImg.image = #imageLiteral(resourceName: "Icon awesome-bookmark")
        }else {
            cell.saveImg.image = #imageLiteral(resourceName: "save")
        }
        
        cell.lblcountry.text =  self.videoRowData[0].data?[indexPath.row].country
        cell.lblCat.text =  self.videoRowData[0].data?[indexPath.row].category
        
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "en_GB")
        relativeDateFormatter.doesRelativeDateFormatting = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM,yyyy"
//        cell.bgImg.downloadImage(url: self.videoRowData[0].data?[indexPath.row].videoThumbnail ?? "")
        let date = getFormattedDate(string: self.videoRowData[0].data?[indexPath.row].dateTime ?? "", formatter: "")
        let date4 = dateFormatter.date(from: date)
        let string = relativeDateFormatter.string(from: date4!)
        
        if string == "Yesterday" || string == "Today" {
            cell.lbldateTime.text = string
        }else {
            cell.lbldateTime.text = date
        }
        
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.size.width, height: bgView.frame.size.height)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let videoCell = cell as? VideoCell else { return }
        videoCell.blurImg.isHidden = true
        videoCell.play()
        let dict = ["sender":UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0,"receiver":self.videoRowData[0].data?[indexPath.row].userID ?? 0,"reciverName": self.videoRowData[0].data?[indexPath.row].username ?? "","userImg":self.videoRowData[0].data?[indexPath.row].username ?? ""] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "videoUserData"), object: dict, userInfo: nil)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videoCell = cell as? VideoCell else { return }
        videoCell.pause()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { check() }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        check()
       if (((scrollView.contentOffset.y + scrollView.frame.size.height) + 0.5 > scrollView.contentSize.height )){
           
            if !isWating && totalPage == 0 {
                self.isWating = false
                page = page + 1
                print("JabyJobPage",page)
                self.isLoad = true
                self.videoList()
            }else {
                //                NotificationCenter.default.post(name: Notification.Name("thumbnail"), object: true)
            }
        }
        
    }
    
    func check() {
        checkPreload()
        checkPlay()
    }
    
    func checkPreload() {
        
        //        videoColl.indexPathsForVisibleItems
        guard let lastRow = videoColl.indexPathsForVisibleItems.last?.row else { return }
        
        let urls = self.vieoUrls
            .suffix(from: min(lastRow + 1, self.vieoUrls.count))
            .prefix(2)
        
        VideoPreloadManager.shared.set(waiting: Array(urls))
    }
    
    func checkPlay() {
        
        if isPlay == false {
            let visibleCells = videoColl.visibleCells.compactMap { $0 as? VideoCell }
            
            guard visibleCells.count > 0 else { return }
            
            let visibleFrame = CGRect(x: 0, y: videoColl.contentOffset.y, width: videoColl.bounds.width, height: videoColl.bounds.height)
            
            let visibleCell = visibleCells
                .filter { visibleFrame.intersection($0.frame).height >= $0.frame.height / 2 }
                .first
            
            visibleCell?.pause()
        }else {
            let visibleCells = videoColl.visibleCells.compactMap { $0 as? VideoCell }
            
            guard visibleCells.count > 0 else { return }
            
            let visibleFrame = CGRect(x: 0, y: videoColl.contentOffset.y, width: videoColl.bounds.width, height: videoColl.bounds.height)
            
            let visibleCell = visibleCells
                .filter { visibleFrame.intersection($0.frame).height >= $0.frame.height / 2 }
                .first
            
            visibleCell?.play()
        }
        
        
        
    }
    
}



extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
