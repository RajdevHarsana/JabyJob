//
//  SenderDoc.swift
//  JabyJob
//
//  Created by DMG swift on 09/05/22.
//

import UIKit

class SenderDoc: UITableViewCell {
    @IBOutlet weak var bgView:UIView!
    @IBOutlet weak var pdfImg:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 20
        bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
