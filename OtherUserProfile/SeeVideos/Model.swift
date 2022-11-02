//
//  Model.swift
//  VideoPlayer
//
//  Created by Mandeep Singh on 06/07/19.
//  Copyright © 2019 Mandeep Singh. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

struct DataSourceModel {
    
    var url: String?
    var videoType: Int?
    var image: String?
}

class ModelObject: NSObject {
    
    static let shared = ModelObject()
    var demoData = [DataSourceModel]()
    
    lazy var videoPlayer : XpPlayerLayer? = {
        let l = XpPlayerLayer()
        l.cacheType = .memory(count: 20)
        l.coverFitType = .fitToVideoRect
        l.videoGravity = AVLayerVideoGravity.resizeAspectFill
        return l
    }()
}
