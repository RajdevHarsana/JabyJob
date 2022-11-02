//
//  InterestCollCell.swift
//  Demo-push
//
//  Created by Arkamac1 on 06/01/22.
//

import UIKit

class InterestCollCell: UICollectionViewCell {
    @IBOutlet weak var borderview: UIView!
    
    @IBOutlet weak var lbl_service: UILabel!
    
  
    
    func cellSetup(){
        
//        borderview.dropShadow(color: UIColor.gray, opacity: 5.0, offSet: CGSize(width: -1, height: 1), radius: 10, scale: true)

//        borderview.setShadow(color : UIColor.gray, opacity : 5, shadowRadius : 5)
    }
    
   
}


extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
