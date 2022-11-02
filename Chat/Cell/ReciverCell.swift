//
//  SenderCell.swift
//  JabyJob
//
//  Created by DMG swift on 28/01/22.
//

import UIKit

class ReciverCell: UITableViewCell {
    
    @IBOutlet weak var lblMsg:UILabel!
    @IBOutlet weak var lblTime:UILabel!
    @IBOutlet weak var bgView:UIView!
    @IBOutlet weak var pdfImg:UIImageView!
    @IBOutlet weak var reciverImage:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let view = UIView()
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 20
        bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMaxXMaxYCorner]
        
//        bgView.roundCorners([.topLeft,.bottomRight,.topRight], radius: 20)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
