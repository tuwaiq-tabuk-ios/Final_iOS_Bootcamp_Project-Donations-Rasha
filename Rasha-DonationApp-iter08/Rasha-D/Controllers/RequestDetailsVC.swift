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
    
    var request : Request?
    
    var chatUser : ChatUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            Firestore.firestore().collection("Users").document(id).getDocument { [self] snapshot, error in
                if error == nil {
                    if let data = snapshot?.data() {
                        let username = data["name"] as? String
                        
                        chatUser = ChatUser(name: username, id: id)
                        
                        usernameLabel.text = username
                        titleLabel.text = request.requestText
                        cityLabel.text = request.city
                        dateLabel.text = request.date
                    }
                }
            }
            
            
        }
        
        
    }
    
    
    @IBAction func directMessageAction(_ sender : UIButton) {
        performSegue(withIdentifier: "goToChatVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChatVC" {
            let nextVC = segue.destination as! ChatVC
            nextVC.user = ChatUser(name: chatUser?.name, id: chatUser?.id)
            
        }
    }
    
}
