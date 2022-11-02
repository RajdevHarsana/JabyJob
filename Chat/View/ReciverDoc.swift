//
//  ReciverDoc.swift
//  JabyJob
//
//  Created by DMG swift on 09/05/22.
//

import UIKit

class ReciverDoc: UITableViewCell {
    @IBOutlet weak var bgView:UIView!
    @IBOutlet weak var pdfImg:UIImageView!
    @IBOutlet weak var reciverImage:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 20
        bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMaxXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
