//
//  itemDetailVC.swift
//  Rasha-D
//
//  Created by rasha  on 19/05/1443 AH.
//

import UIKit
import Firebase

class itemDetailVC: UIViewController {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var directMessageButton: UIButton!
    
    var passedItem : Item?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground()
        itemImageView.layer.cornerRadius = 10
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 5
        directMessageButton.layer.cornerRadius = 22.5
        
        if let item = passedItem {
            if let imageUrlString = item.imageUrl {
                if let imageURL = URL(string: imageUrlString) {
                    itemImageView.sd_setImage(with: imageURL) { image, error, cache, url in
                        if error == nil {
                            DispatchQueue.main.async {
                                self.itemImageView.image = image
                            }
                        }
                    }
                }
            }
            
            itemTitleLabel.text = item.title
            cityLabel.text = item.city
            descriptionTextView.text = item.description
            userNameLabel.text = item.username
            dateLabel.text = item.date
            directMessageButton.setTitle("Direct Message With \(item.username!)", for: .normal)
            guard let userId = Auth.auth().currentUser?.uid else {return}
            if item.userID == userId {
                directMessageButton.isHidden = true
            }
        }
    }
    
    @IBAction func directMessageAction(_ sender: UIButton) {
        performSegue(withIdentifier: "goToChatVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChatVC" {
            let nextVC = segue.destination as! ChatVC
            nextVC.user = ChatUser(name: passedItem?.username, id: passedItem?.userID)
        }
    }
    
    
}


