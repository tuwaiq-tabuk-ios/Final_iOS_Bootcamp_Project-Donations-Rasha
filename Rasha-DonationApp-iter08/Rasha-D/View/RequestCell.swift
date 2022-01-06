//
//  RequestCell.swift
//  Rasha-D
//
//  Created by rasha  on 29/05/1443 AH.
//

import UIKit

class RequestCell: UITableViewCell {
    
    @IBOutlet weak var requestTextLabel : UILabel!
    @IBOutlet weak var cityLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var containerView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .init(white: 0.95, alpha: 0.2)
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.init(white: 0.95, alpha: 0.6).cgColor
    }

   
    
}
