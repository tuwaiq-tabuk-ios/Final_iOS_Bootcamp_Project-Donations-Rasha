//
//  ChatVC.swift
//  Rasha-D
//
//  Created by rasha  on 20/05/1443 AH.
//

import UIKit
import Firebase


class ChatVC: UIViewController {
    
    var item : Item?

    @IBOutlet weak var chatTabelView: UITableView!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.title = item?.username
        chatTabelView.delegate = self
        chatTabelView.dataSource = self

       
    }

    @IBAction func sendMessageButtonAction(_ sender: UIButton) {
        guard  let senderID = Auth.auth().currentUser?.uid else {return}
       guard let recieverId = item?.userID else {return}
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-M-YYYY"
        let currentDate = formatter.string(from: Date())
        if let message = messageTextView.text, message.isEmpty == false {
            // send message
            let message = ["sender" : senderID, "reciiver" : recieverId , "data" : currentDate, "message" : message]
            Firestore.firestore().collection("Messages").document(UUID().uuidString).setData(message) { error in
                if error == nil {
                    print("Message Successfully sent")
                }
            }
                
                
        }
        
      
    }
    
    }
    
extension ChatVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTabelView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Rasha"
        return cell
    }
    
   
}

