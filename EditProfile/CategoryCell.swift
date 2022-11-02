//
//  CategoryCell.swift
//  JabyJob
//
//  Created by DMG swift on 18/02/22.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var checkImg:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
