//
//  VideoListOtherUser.swift
//  JabyJob
//
//  Created by DMG swift on 25/03/22.
//

import UIKit
import TTGSnackbar
import GSPlayer
class VideoListOtherUser: UIViewController {
    @IBOutlet weak var bgView: UIView!
    //    let layout = UICollectionViewFlowLayout()
    @IBOutlet weak var videoColl: UICollectionView!
    
    var videoRowData = [OtherUserInfoModal]()
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
    var isPlay = true
    var vieoUrls = [URL]()
    var videoTag = Int()
    var isVideo = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
        videoColl.delegate = self
        videoColl.dataSource = self
        videoColl.bounces = true
        self.videoColl.isPagingEnabled = true
        self.videoColl.contentMode = .scaleAspectFill
        
        //        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        videoColl.refreshControl = refreshControl // iOS 10+
        videoColl.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        check()
    }
    
    //    @objc private func didPullToRefresh(_ sender: Any) {
    //        self.getOtherUserInfoApi()
    //        refreshControl.endRefreshing()
    //    }
    @IBAction func btnDidTapBack(_ sender: UIButton) {
        isPlay = false
        check()
        self.dismiss(animated: false) {
            //            self.isBack = true
            //            self.self.playFirstVisibleVideo(false)
        }
        
        //        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isFromSave == true {
            self.skills = self.saveVidolist[0].data?[0].skills ?? [""]
            
        }else {
            _ = self.videoRowData[0].skill?.compactMap({ list in
                self.skills.append(list.skill?.name ?? "")
            })
            
            for i in 0..<(self.videoRowData.count){
                let url = URL(string: "videobaseurl" + (self.videoRowData[0].video?[i].name ?? ""))
                self.vieoUrls.append(url!)
            }
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        if isFromSave == true {
        }else{
            if isVideo == true{
                let indexPath = IndexPath(item: videoTag, section: 0)
                
                self.videoColl.scrollToItem(at: indexPath, at: [.centeredVertically], animated: false)
                videoColl.isScrollEnabled = false
            }else{
                
            }
            
        }
        
    }
    
    private func getOtherUserInfoApi(){
        
        let param = ["id":idUser] as JsonDict
        ApiClass().getOtherUserInfo(view: self.view, inputUrl: baseUrl+"another-profile", parameters: param, header: userToken) { result
            in
            self.videoRowData.removeAll()
            self.skills.removeAll()
            self.videoRowData.append(result as! OtherUserInfoModal)
            _ = self.videoRowData[0].skill?.compactMap({ list in
                self.skills.append(list.skill?.name ?? "")
            })
            self.videoColl.reloadData()
            print(result)
        }
    }
}

extension VideoListOtherUser:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @objc func didTapSave(_ sender:UIButton){
        
        if isFromSave == true {
            
            let dict = ["video_id":self.saveVidolist[0].data?[sender.tag].videoID ?? 0] as JsonDict
            if self.saveVidolist[0].data?[sender.tag].saveVideoStatus == true {
                ApiClass().deleteVideoApi(view: self.view, inputUrl: baseUrl+"remove-saved-video", parameters: dict, header: self.userToken) { result in
                    print(result)
                    
                    let dict = result as? JsonDict
                    if dict?["status"] as? Int == 1 {
                        self.getOtherUserInfoApi()
                        //                                self.userProfile()
                    }
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
                        
                        let indexPath = IndexPath(item: sender.tag, section: 0)
                        
                        self.saveIndex = indexPath
                        
                        self.isSave = true
                        
                        self.getOtherUserInfoApi()
                        
                    }
                }
            }
            
        } else {
            let dict = ["video_id":self.videoRowData[0].video?[sender.tag].id ?? 0] as JsonDict
            if self.videoRowData[0].video?[sender.tag].savedStatus == true {
                ApiClass().deleteVideoApi(view: self.view, inputUrl: baseUrl+"remove-saved-video", parameters: dict, header: self.userToken) { result in
                    print(result)
                    
                    let dict = result as? JsonDict
                    if dict?["status"] as? Int == 1 {
                        self.getOtherUserInfoApi()
                        //                                self.userProfile()
                    }
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
                        
                        let indexPath = IndexPath(item: sender.tag, section: 0)
                        
                        self.saveIndex = indexPath
                        
                        self.isSave = true
                        
                        self.getOtherUserInfoApi()
                        
                    }
                }
            }
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFromSave == true {
            return self.saveVidolist[0].data?.count ?? 0
        }else {
            return self.videoRowData[0].video?.count ?? 0
        }
    }
    @objc func didTapRepoert(_ sender: UITapGestureRecognizer){
        
        if self.userToken == "" {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UserTypeVC")
            
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            
            if isFromSave == true {
                //                saveVidolist[0].data?[indexPath.row].saveVideoStatus
                guard let getTag = sender.view?.tag else { return }
                let storyboard = UIStoryboard(name: "Report", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
                vc.videoId = saveVidolist[0].data![getTag].videoID!//self.videoRowData[0].data?[getTag].videoID ?? 0
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: false) {
                }
            }else {
                guard let getTag = sender.view?.tag else { return }
                let storyboard = UIStoryboard(name: "Report", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
                vc.videoId = self.videoRowData[0].video![getTag].id!//self.videoRowData[0].data?[getTag].videoID ?? 0
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: false) {
                }
            }
            
        }
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
            if isFromSave == true {
                cell.lblUserName.text = "@"+(self.saveVidolist[0].data?[indexPath.row].username ?? "")
                
                cell.btnSave.addTarget(self, action: #selector(didTapSave(_:)), for: .touchUpInside)
                cell.btnSave.tag = indexPath.row
                
                let reportTap = UITapGestureRecognizer(target: self, action: #selector(didTapRepoert(_:)))
                //        cell.btnUserTap.addTarget(self, action: #selector(didTapUserName(_:)), for: .touchUpInside)
                cell.btnUserTap.tag = indexPath.row
                cell.reportView.addGestureRecognizer(reportTap)
                //        tap.view?.tag =  $0.tag
                cell.reportView.tag = indexPath.row
                //        cell.playerInitialization()
                
                let videoUrldata = saveVidolist[0].data?[indexPath.row].video ?? ""
                cell.set(url:videoUrldata)
                //                cell.addPlayer(for: URL(string: videoUrldata)!)
                //                    if !isPlayed {
                //                        cell.avQueuePlayer?.play()
                //                        isPlayed = true
                //                    }
                
                if saveVidolist[0].data?[indexPath.row].saveVideoStatus == false {
                    cell.saveImg.image = #imageLiteral(resourceName: "Icon awesome-bookmark")
                }else {
                    cell.saveImg.image = #imageLiteral(resourceName: "save")
                }
            }else {
                cell.lblUserName.text = "@"+(self.videoRowData[0].data?.user?.fullName ?? "")
                cell.btnSave.addTarget(self, action: #selector(didTapSave(_:)), for: .touchUpInside)
                cell.btnSave.tag = indexPath.row
                let reportTap = UITapGestureRecognizer(target: self, action: #selector(didTapRepoert(_:)))
                cell.btnUserTap.tag = indexPath.row
                cell.reportView.addGestureRecognizer(reportTap)
                cell.reportView.tag = indexPath.row
                let videoUrldata = videobaseurl + (videoRowData[0].video?[indexPath.row].name ?? "")
                cell.set(url:videoUrldata)
                if self.videoRowData[0].video?[indexPath.row].savedStatus == false {
                    cell.saveImg.image = #imageLiteral(resourceName: "Icon awesome-bookmark")
                }else {
                    cell.saveImg.image = #imageLiteral(resourceName: "save")
                }
            }
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





import UIKit
import AVFoundation
import AVKit
import iOSDropDown
//import Player
import SDWebImage
import GSPlayer

class CollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var btnUserTap:UIButton!
    @IBOutlet weak var playerView: VideoPlayerView!
    @IBOutlet weak var dropDown : DropDown!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var shareView: UIStackView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var reportView:UIView!
    @IBOutlet weak var saveImg:UIImageView!
    @IBOutlet weak var lblSkills:UILabel!
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var bgImg:UIImageView!
    @IBOutlet weak var btnShare:UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var btnFav: UIButton!
    
//    var avQueuePlayer: AVQueuePlayer?
//    var avPlayerLayer: AVPlayerLayer?
    private var url: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgImg.isHidden = true
        playerView.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
    
//        self.playerVideoGravity = playerView.playerLayer.videoGravity
//        playerView.playerLayer.videoGravity = fullscreenVideoGravity
        //        self.setUpUI()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(thumnailImage(notification:)), name: Notification.Name("thumbnail"), object: nil)
        
        
        playerView.stateDidChanged = { state in
            switch state {
            case .none:
                print("none")
            case .error(let error):
                print("error - \(error.localizedDescription)")
            case .loading:
                self.activity.startAnimating()
                self.activity.isHidden = false
                //                self.bgImg.isHidden = false
                //                playerView.isHidden = true
                print("loadingDk")
            case .paused(let playing, let buffering):
                print("paused - progress \(Int(playing * 100))% buffering \(Int(buffering * 100))%")
            case .playing:
                self.activity.stopAnimating()
                self.activity.isHidden = true
                //               self.bgImg.isHidden = true
                //                self.playerView.isHidden = false
                print("playingDK")
            }
        }
        
    }
    
    @objc func finishVideo()
    {
        print("Video Finished")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        playerView.isHidden = true
    }
    
    func set(url: String) {
        
        self.url = URL(string: url)
    }
    
    func play() {
        playerView.play(for: url)
        playerView.isHidden = false
        
    }
    
    func pause() {
        playerView.pause(reason: .hidden)
    }
    
    @IBAction func btnFav(_ sender: UIButton) {
        
        if sender.isSelected == true {
            btnFav.setImage(UIImage(named: "play"), for: .normal)
            sender.isSelected = false
            
        }else
        {
            btnFav.setImage(UIImage(named: "pause"), for: .normal)
            sender.isSelected = true
        }
    }
}


