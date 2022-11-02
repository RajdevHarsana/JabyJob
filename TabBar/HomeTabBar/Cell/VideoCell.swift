//
//  VideoCell.swift
//  TikTokVideoDemo
//
//  Created by DMG swift on 28/12/21.
//

import UIKit
import AVFoundation
import AVKit
import iOSDropDown
//import Player
import SDWebImage
import GSPlayer
var isPlayerIsReady = false

class VideoCell: UICollectionViewCell {
    @IBOutlet weak var btnUserTap:UIButton!
    @IBOutlet weak var playerView: VideoPlayerView!
    @IBOutlet weak var dropDown : DropDown!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var shareView: UIStackView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var reportView:UIView!
    @IBOutlet weak var saveImg:UIImageView!
    @IBOutlet weak var lblSkills:UILabel!
    @IBOutlet weak var lbldateTime:UILabel!
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var lblcountry:UILabel!
    @IBOutlet weak var lblCat:UILabel!
    @IBOutlet weak var bgImg:UIImageView!
    @IBOutlet weak var blurImg:UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var btnFav: UIButton!
    private var url: URL!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgImg.isHidden = true
        playerView.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
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
    
    
//    @objc func thumnailImage(notification: Notification) {
//
//        if notification.object as? Bool == false {
//            print("ImageDineshNot")
////            DispatchQueue.main.async {
//                self.bgImg.isHidden = false
////            }
//
//        }else {
//
//                print("ImageDinesh")
//                self.blurImg.isHidden = false
//
//
//                self.bgImg.isHidden = true
//                self.playerView.isHidden = false
////            }
//        }
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("thumbnail"), object: nil)
//
////        NotificationCenter.removeObserver("thumbnail")
//
//        //        if notification.object
//    }
    
    @IBAction func btnFav(_ sender: UIButton) {
        
        if sender.isSelected == true {
            //btnFav.setImage("play",forState: .normal)
            btnFav.setImage(UIImage(named: "play"), for: .normal)

//            player!.play()
            sender.isSelected = false

        }else

        {
           // btnFav.setImage("pause",forState: .selected)
            btnFav.setImage(UIImage(named: "pause"), for: .normal)
//            player?.pause()
            sender.isSelected = true
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
}


