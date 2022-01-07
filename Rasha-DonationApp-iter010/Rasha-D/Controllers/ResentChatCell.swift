//
//  ResentChatCell.swift
//  Rasha-D
//
//  Created by rasha  on 23/05/1443 AH.
//

import UIKit

class ResentChatCell: UITableViewCell {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
