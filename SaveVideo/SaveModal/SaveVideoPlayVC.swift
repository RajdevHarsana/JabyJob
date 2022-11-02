//
//  SaveVideoPlayVC.swift
//  JabyJob
//
//  Created by DMG swift on 11/04/22.
//

import UIKit
import TTGSnackbar
import FirebaseDynamicLinks
import GSPlayer
class SaveVideoPlayVC: UIViewController {
    @IBOutlet weak var bgView: UIView!
//    let layout = UICollectionViewFlowLayout()
    @IBOutlet weak var videoColl: UICollectionView!
    private var saveIndex = IndexPath()
    private var isSave = false
    private var refreshControl = UIRefreshControl()
    var idUser = Int()
    private var skills = [String]()
    var userToken = ""
    var isBack = false
    var isPlayed: Bool = false
    var gradient : CAGradientLayer?
   var isFromSave = false
    var saveVidolist = [SaveVideoModal]()
    var videoRowData = [OtherUserInfoModal]()
    var updateDelegate:updateData? = nil
    var index = Int()
    var isPlay = true
    var vieoUrls = [URL]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
        videoColl.delegate = self
        videoColl.dataSource = self
        videoColl.bounces = true
        self.videoColl.isPagingEnabled = true
        self.videoColl.contentMode = .scaleAspectFill
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
       videoColl.refreshControl = refreshControl // iOS 10+
        videoColl.reloadData()
        videoColl.scrollToItem(at:IndexPath(item: index, section: 0), at: .bottom, animated: false)
        
    }
//    override func viewDidLayoutSubviews() {
//
//
//    }
  
//    override func viewDidAppear(_ animated: Bool) {
//        self.videoColl.safeAdd(observer: self, forKeyPath: "contentOffset", options: [.new], context: nil)
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        self.stopIt(isStart: true)
//        self.videoColl.safeRemove(observer: self, forKeyPath: "contentOffset")
//    }
    
    //MARK:- viewWillDisappear
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.stopIt(isStart: true)
//    }
    
//    private func stopIt(isStart:Bool) {
//        guard let player = ModelObject.shared.videoPlayer else { return }
//        player.isStopPlayer = isStart
//    }
    
    @objc private func didPullToRefresh(_ sender: Any) {
        self.getOtherUserInfoApi()
        refreshControl.endRefreshing()
    }
    @IBAction func btnDidTapBack(_ sender: UIButton) {
      
        isPlay = false
        check()
        
        self.dismiss(animated: false) {
            self.updateDelegate?.updatedata()
//            self.isBack = true
//            self.self.playFirstVisibleVideo(false)
        }
        
        
        
//        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
            self.skills = self.saveVidolist[0].data?[0].skills ?? [""]
        
        for i in 0..<(self.saveVidolist.count){
            let url = URL(string: "videobaseurl" + (self.saveVidolist[0].data?[i].video ?? ""))
            self.vieoUrls.append(url!)
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        check()
    }
    private func getOtherUserInfoApi(){
      
        let param = ["id":idUser] as JsonDict
        ApiClass().getOtherUserInfo(view: self.view, inputUrl: baseUrl+"another-profile", parameters: param, header: userToken) { result
            in
            self.videoRowData.removeAll()
//            self.skills.removeAll()
            self.videoRowData.append(result as! OtherUserInfoModal)
//            _ = self.videoRowData[0].skill?.compactMap({ list in
//                self.skills.append(list.skill?.name ?? "")
//            })
            
            
            for i in 0..<(self.videoRowData[0].video?.count ?? 0) {
                if self.videoRowData[0].video?[i].savedStatus != self.saveVidolist[0].data?[i].saveVideoStatus{
                    self.saveVidolist[0].data?[i].saveVideoStatus = self.videoRowData[0].video?[i].savedStatus
                }
            }
                  
            self.videoColl.reloadData()
            print(result)
        }
    }
}

extension SaveVideoPlayVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @objc func didTapSave(_ sender:UIButton){
        
//        if isFromSave == true {
            
            let dict = ["video_id":self.saveVidolist[0].data?[sender.tag].videoID ?? 0] as JsonDict
            if self.saveVidolist[0].data?[sender.tag].saveVideoStatus == true {
                ApiClass().deleteVideoApi(view: self.view, inputUrl: baseUrl+"remove-saved-video", parameters: dict, header: self.userToken) { result in
                    print(result)
                    
                    let dict = result as? JsonDict
                    if dict?["status"] as? Int == 1 {
                        if self.saveVidolist[0].data?[sender.tag].saveVideoStatus == true {
                           self.saveVidolist[0].data?[sender.tag].saveVideoStatus = false
                        }
                    }
                    let indexPath = IndexPath(item: sender.tag, section: 0)
                    
                    self.saveIndex = indexPath
                    
                    self.isSave = true
                    self.videoColl.reloadData()
                    let snackbar = TTGSnackbar(message: dict?["message"] as? String ?? "", duration: .short)
                    snackbar.show()
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
                        
                       
                        
                        if self.saveVidolist[0].data?[sender.tag].saveVideoStatus == false {
                            self.saveVidolist[0].data?[sender.tag].saveVideoStatus = true
                         }
                        let indexPath = IndexPath(item: sender.tag, section: 0)
                        
                        self.saveIndex = indexPath
                        
                        self.isSave = true
                        
                        self.videoColl.reloadData()
//                        self.getOtherUserInfoApi()
                        
                    }
                }
            }
            
//        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    
           return self.saveVidolist[0].data?.count ?? 0
       
    }
    @objc func didTapRepoert(_ sender: UITapGestureRecognizer){
        
        if self.userToken == "" {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UserTypeVC")
            
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            
           
//                saveVidolist[0].data?[indexPath.row].saveVideoStatus
                guard let getTag = sender.view?.tag else { return }
                let storyboard = UIStoryboard(name: "Report", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
                vc.videoId = saveVidolist[0].data![getTag].videoID!//self.videoRowData[0].data?[getTag].videoID ?? 0
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: false) {
                }

            
        }
    }
    
    @objc func didTapShare(_ sender:UIButton){
        let videoId = self.saveVidolist[0].data?[sender.tag].videoID ?? 0
        
        guard let videoNmae = self.saveVidolist[0].data?[sender.tag].video else { return }
        let userId = self.saveVidolist[0].data?[sender.tag].userID
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
        shareLink.socialMetaTagParameters?.title = self.saveVidolist[0].data?[sender.tag].username ?? ""
        shareLink.socialMetaTagParameters?.descriptionText = "safk;hsdjklbchasbjkhgsuabdhkcjbasdkhjcgjkasdbcjhgasdhjbcasdlgcabsdc"
        shareLink.socialMetaTagParameters?.imageURL =  URL(string: self.saveVidolist[0].data?[sender.tag].videoThumbnail ?? "")
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
    
//    @objc func didTapUserName(_ sender:UIButton){
//
//        let storyboard = UIStoryboard(name: "OtherProfile", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
//        vc.id = self.videoRowData[0].data?[sender.tag].userID ?? 0
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) is CollectionCell {
            
            let cell = videoColl.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
            
            cell.lblSkills.text = self.skills.map{String($0)}.joined(separator: ",")
//            if isFromSave == true {
                cell.lblUserName.text = "@"+(self.saveVidolist[0].data?[indexPath.row].username ?? "")
                
                cell.btnSave.addTarget(self, action: #selector(didTapSave(_:)), for: .touchUpInside)
                cell.btnSave.tag = indexPath.row
            cell.btnShare.tag = indexPath.row
            cell.btnShare.addTarget(self, action: #selector(didTapShare(_:)), for: .touchUpInside)
                let reportTap = UITapGestureRecognizer(target: self, action: #selector(didTapRepoert(_:)))
        //        cell.btnUserTap.addTarget(self, action: #selector(didTapUserName(_:)), for: .touchUpInside)
                cell.btnUserTap.tag = indexPath.row
                cell.reportView.addGestureRecognizer(reportTap)
                //        tap.view?.tag =  $0.tag
                cell.reportView.tag = indexPath.row
        //        cell.playerInitialization()
                
             
            let videoUrldata = saveVidolist[0].data?[indexPath.row].video ?? ""
            cell.set(url:videoUrldata)
                
                if saveVidolist[0].data?[indexPath.row].saveVideoStatus == false {
                    cell.saveImg.image = #imageLiteral(resourceName: "Icon awesome-bookmark")
                }else {
                    cell.saveImg.image = #imageLiteral(resourceName: "save")
                }
//            }
            
            
            return cell
        }
        return UICollectionViewCell()
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
        
//        let m = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        return CGSize.init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        

    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        videoColl.visibleCells.forEach { cell in
            // TODO: write logic to stop the video before it begins scrolling
            let cell = cell as! CollectionCell
            cell.pause()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let videoCell = cell as? CollectionCell else { return }
        videoCell.bgImg.isHidden = true
        videoCell.play()
        //        let dict = ["sender":UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0,"receiver":self.videoRowData[0].data?[indexPath.row].userID ?? 0,"reciverName": self.videoRowData[0].data?[indexPath.row].username ?? "","userImg":self.videoRowData[0].data?[indexPath.row].username ?? ""] as [String : Any]
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "videoUserData"), object: dict, userInfo: nil)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videoCell = cell as? CollectionCell else { return }
        videoCell.pause()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { check() }
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
            let visibleCells = videoColl.visibleCells.compactMap { $0 as? CollectionCell }
            
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




