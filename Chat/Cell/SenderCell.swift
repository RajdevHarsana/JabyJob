//
//  ReciverCell.swift
//  JabyJob
//
//  Created by DMG swift on 28/01/22.
//

import UIKit

class SenderCell: UITableViewCell {
    @IBOutlet weak var lbltime:UILabel!
    @IBOutlet weak var lblMsg:UILabel!
    @IBOutlet weak var bgView:UIView!
    @IBOutlet weak var pdfImg:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 20
        bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        let firstcolor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.9568627451, alpha: 1)
        let secondcolor = #colorLiteral(red: 0.1647058824, green: 0.4588235294, blue: 0.737254902, alpha: 1)
          let gradientLayer:CAGradientLayer = CAGradientLayer()
          gradientLayer.frame.size = self.bgView.frame.size
          gradientLayer.colors =
          [firstcolor,secondcolor]
          //Use diffrent colors
        self.bgView.layer.addSublayer(gradientLayer)
        
        
        
//        bgView.backgroundColor = .blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension UIView {

    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
         
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            //top to bottom
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }

}
