//
//  ChatCell.swift
//  Rasha-D
//
//  Created by rasha  on 22/05/1443 AH.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageViewLeft: NSLayoutConstraint!
    
    
    @IBOutlet weak var messageViewRight: NSLayoutConstraint!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        messageView.layer.cornerRadius = 12
        messageViewLeft.priority = .defaultLow
    }
    
}
