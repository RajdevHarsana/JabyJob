//
//  MenuListCell.swift
//  Demo-push
//
//  Created by Arkamac1 on 10/01/22.
//

import UIKit

class MenuListCell: UITableViewCell {
    @IBOutlet weak var imglist: UIImageView!
    @IBOutlet weak var lbl_MenuName: UILabel!
    @IBOutlet weak var Btn_Switch: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Btn_Switch.setImage(UIImage(named: ""), for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
