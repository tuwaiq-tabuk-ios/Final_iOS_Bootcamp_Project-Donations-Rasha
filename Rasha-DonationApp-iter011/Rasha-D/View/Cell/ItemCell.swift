//
//  ItemCell.swift
//  Rasha-D
//
//  Created by rasha  on 14/05/1443 AH.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemImageView.layer.borderColor = UIColor.lightGray.cgColor
        itemImageView.layer.borderWidth = 1
        itemImageView.layer.cornerRadius = 5
    }

    
}
