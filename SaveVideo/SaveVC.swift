//
//  SearchVC.swift
//  JabyJob
//
//  Created by DMG swift on 25/01/22.
//

import UIKit
import TTGSnackbar
import SDWebImage
import AVFoundation
import MobileCoreServices
import AVKit
protocol updateData {
    func updatedata()
}



class SaveVC: BaseViewController,updateData {
    func updatedata() {
        saveVideoList()
    }
    @IBOutlet weak var colletionMy: UICollectionView!
    private var saveList = [SaveVideoModal]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        saveVideoList()
        // Do any additional setup after loading the view.
    }
    
    
   private func saveVideoList(){
       let userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
       ApiClass().saveVideoListApi(view: self.view, inputUrl: baseUrl+"get-saved-video", parameters: [:], header: userToken) { result in
           self.saveList.removeAll()
           let list = result as! SaveVideoModal
           
           if list.status == false {
               let snackbar = TTGSnackbar(message: list.message ?? "", duration: .short)
               snackbar.show()
           }else {
              
               self.saveList.append(result as! SaveVideoModal)
           }
           self.colletionMy.reloadData()
           print(result)
       }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    @IBAction func BtndidTapBack(_ sender:UIButton) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name("videoList"), object: true)
        }
    }
    
    
    @objc func didTapPlayVideo(_ sender:UIButton){
//        let data = self.saveList[0].data?[sender.tag]
//        let videoURL = URL(string: data?.video ?? "")
//        let player = AVPlayer(url: videoURL!)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.present(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
        
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SaveVideoPlayVC") as! SaveVideoPlayVC
        vc.idUser = self.saveList[0].data?[0].userID ?? 0
        vc.saveVidolist = self.saveList
        vc.updateDelegate = self
        vc.index = sender.tag
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
}


extension SaveVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if saveList.count > 0 {
            return saveList[0].data?.count ?? 0
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colletionMy.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! ProfileCollCell
        
        
        let data = self.saveList[0].data?[indexPath.row]
        cell.img_user.sd_setImage(with: URL(string:(data?.videoThumbnail ?? "")), placeholderImage: UIImage(named: "file-video-icon-256"), options: .refreshCached) { (image, error, cacheType, url) in
//                    self.userImg.image = image
        }
        cell.btn_play.addTarget(self, action: #selector(self.didTapPlayVideo(_:)), for: .touchUpInside)
        cell.btn_play.tag = indexPath.row
        
        
        
//        if isDocrOrVideo == false{
//            cell.img_user.image = UIImage(named: "speaker1")
//        }else {
//            cell.img_user.image = UIImage(named: "cv-1")
//        }
        return cell
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
