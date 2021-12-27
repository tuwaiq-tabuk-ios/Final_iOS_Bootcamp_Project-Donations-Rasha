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
    var messages = [Message]()
    
    
    @IBOutlet weak var chatTabelView: UITableView!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = item?.username
        chatTabelView.delegate = self
        chatTabelView.dataSource = self
        chatTabelView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        getMessages()
        
    }
    
    @IBAction func sendMessageButtonAction(_ sender: UIButton) {
        
        guard  let senderID = Auth.auth().currentUser?.uid else {return}
        guard let recieverId = item?.userID else {return}
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-M-YYYY"
        let currentDate = formatter.string(from: Date())
        formatter.dateFormat = "h:m a"
        let currentTime = formatter.string(from: Date())
        print(currentTime)
        
        
        // add message timestamp
        let timestamp = String(Date().timeIntervalSince1970)
        
        if let message = messageTextView.text, message.isEmpty == false {
            // send message
            let message = ["sender" : senderID, "reciever" : recieverId , "date" : currentDate, "message" : message , "timestamp" : timestamp , "time" : currentTime]
            Firestore.firestore().collection("Messages").document(UUID().uuidString).setData(message) { error in
                if error == nil {
                    print("Message Successfully sent")
                    self.messageTextView.text = ""
                }
            }
            
            
        }
        
        
    }
    
    
    func getMessages() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        guard let userId = item?.userID else {return}
        Firestore.firestore().collection("Messages").addSnapshotListener { snapshot, error in
            self.messages.removeAll()
            if let value = snapshot?.documents {
                for i in value {
                    let data = i.data()
                    let message = data["message"]as? String
                    let sender = data["sender"]as? String
                    let reciever = data["reciever"]as? String
                    let date = data["date"]as? String
                    let timestamp = data["timestamp"]as? TimeInterval
                    let time = data["time"] as? String
                    
                    if (sender == currentUserID && reciever == userId) || (sender == userId && reciever == currentUserID) {
                        self.messages.append(Message(sender: sender, reciever: reciever, message: message, date: date , timestamp: timestamp, time: time))
                    }
                    
                }
//                self.messages = self.messages.sorted(by: {$0.timestamp! < $1.timestamp!})
                self.chatTabelView.reloadData()
                
            }
        }
    }
}
    
extension ChatVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTabelView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatCell
        cell.messageLabel.text = messages[indexPath.row].message
        cell.messageLabel.textColor = .red
        
        if messages[indexPath.row].sender == Auth.auth().currentUser?.uid {
            cell.messageViewLeft.priority = .defaultLow
            cell.messageViewRight.priority = .defaultHigh
        }else {
            cell.messageViewLeft.priority = .defaultHigh
            cell.messageViewRight.priority = .defaultLow
        }
        
        return cell
    }
    
   
}

 

