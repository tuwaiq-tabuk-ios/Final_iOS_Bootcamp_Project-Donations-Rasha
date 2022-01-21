//
//  RequestDetailsVC.swift
//  Rasha-D
//
//  Created by rasha  on 29/05/1443 AH.
//

import UIKit
import Firebase

class RequestDetailsVC: UIViewController {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var usernameLabel : UILabel!
    @IBOutlet weak var cityLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var directMessageButton : UIButton!
    @IBOutlet weak var titleContainerView : UIView!
    
    
    var request : Request?
    
    var chatUser : ChatUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.alpha = 0
        usernameLabel.alpha = 0
        cityLabel.alpha = 0
        dateLabel.alpha = 0
        
        titleContainerView.layer.cornerRadius = 10
        titleContainerView.layer.borderWidth = 1
        titleContainerView.layer.borderColor = UIColor.gray.cgColor
        directMessageButton.layer.cornerRadius = 10
        
        setGradientBackground()
        
        if let uid = Auth.auth().currentUser?.uid, let id = request?.userID {
            if id == uid {
                directMessageButton.isHidden = true
            } else {
                directMessageButton.isHidden = false
            }
        }
        
        if let request = request {
            guard let id = request.userID else {return}
            Firestore.firestore().collection(FSCollectionReference.users.rawValue).document(id).getDocument { [self] snapshot, error in
                if error == nil {
                    if let data = snapshot?.data() {
                        let username = data["name"] as? String
                        
                        chatUser = ChatUser(name: username, id: id)
                        
                        usernameLabel.text = username
                        titleLabel.text = request.requestText
                        cityLabel.text = request.city
                        dateLabel.text = request.date
                        
                        titleLabel.alpha = 1
                        usernameLabel.alpha = 1
                        cityLabel.alpha = 1
                        dateLabel.alpha = 1
                    }
                }
            }
            
            
        }
        
        
    }
    
    
    @IBAction func directMessageAction(_ sender : UIButton) {
        performSegue(withIdentifier: SegueIdentifires.goToChatVC, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifires.goToChatVC {
            let nextVC = segue.destination as! ChatVC
            nextVC.user = ChatUser(name: chatUser?.name, id: chatUser?.id)
            
        }
    }
    
}
