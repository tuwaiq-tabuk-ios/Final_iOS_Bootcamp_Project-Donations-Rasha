//
//  ChatVC.swift
//  Rasha-D
//
//  Created by rasha  on 20/05/1443 AH.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class ChatVC: UIViewController {
    
    @IBOutlet weak var messageViewBotton: NSLayoutConstraint!
    
    var messages = [Message]()
    var user : ChatUser?
    
    @IBOutlet weak var chatTabelView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    
    var bottomPadding : CGFloat = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            if let safeAreaBottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                bottomPadding = safeAreaBottomPadding
            }
        }
        
        IQKeyboardManager.shared.enable = false
        keyboardSetting()
        setGradientBackground()
        
        messageTextView.layer.cornerRadius = 10
        messageTextView.delegate = self
        
        
        navigationItem.title = user?.name
        chatTabelView.delegate = self
        chatTabelView.dataSource = self
        chatTabelView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        getMessages()
        
    }
    
    @IBAction func sendMessageButtonAction(_ sender: UIButton) {
        
        guard  let senderID = Auth.auth().currentUser?.uid else {return}
        guard let recieverId = user?.id else {return}
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-M-YYYY"
        let currentDate = formatter.string(from: Date())
        formatter.dateFormat = "h:m a"
        let currentTime = formatter.string(from: Date())
        print(currentTime)
        
        
        // add message timestamp
        
        let timestamp = Date().timeIntervalSince1970
        
        if let message = messageTextView.text, message.isEmpty == false {
            // send message
            let message : [String : Any] = ["sender" : senderID, "reciever" : recieverId , "date" : currentDate, "message" : message , "timestamp" : timestamp , "time" : currentTime]
            Firestore.firestore().collection("Messages").document(UUID().uuidString).setData(message) { error in
                if error == nil {
                    print("Message Successfully sent")
                    self.messageTextView.text = ""
                    self.chatTabelView.scrollToBottomRow()
                }
            }
        }
    }
    
    
    func getMessages() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.id else {return}
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
                self.messages = self.messages.sorted(by: {$0.timestamp! < $1.timestamp!})
                self.chatTabelView.reloadData()
                self.chatTabelView.scrollToBottomRow()
                
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
        cell.timeLabel.text = messages[indexPath.row].time
        
      
        if messages[indexPath.row].sender == Auth.auth().currentUser?.uid {
            cell.messageViewLeft.priority = .defaultLow
            cell.messageViewRight.priority = .defaultHigh
            cell.timeLabel.textAlignment = .right
            cell.messageView.backgroundColor = Colors.senderMessageView
        } else {
            cell.messageViewLeft.priority = .defaultHigh
            cell.messageViewRight.priority = .defaultLow
            cell.timeLabel.textAlignment = .left
            cell.messageView.backgroundColor = Colors.recieverMessageView
        }
        
        return cell
    }
}
extension UITableView {
    func scrollToBottomRow() {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }
            
            // Make an attempt to use the bottom-most section with at least one row
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)
            
            // Ensure the index path is valid, otherwise use the section above (sections can
            // contain 0 rows which leads to an invalid index path)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)
                
                // If we're down to the last section, attempt to use the first row
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }
            
            // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
            // exception here
            
            guard self.indexPathIsValid(indexPath) else { return }
            
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
}


extension ChatVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "message here".localize() {
            textView.text = ""
            textView.textColor = Colors.darkGrayWhite
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "message here"
            textView.textColor = .lightGray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


extension ChatVC {
    
    func keyboardSetting() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardNotification(notification : NSNotification) {
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            messageViewBotton.constant = isKeyboardShowing ? -(keyboardFrame!.height) + bottomPadding : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                print(self.messageViewBotton.constant)
            }) { (completed) in

            }
        }
    }
}
