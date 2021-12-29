//
//  ResentChatVC.swift
//  Rasha-D
//
//  Created by rasha  on 23/05/1443 AH.
//

import UIKit
import Firebase

class RecentChatsVC: UITableViewController {
    let cellId = "Cell"
    var recentChats = [ChatUser]()

    override func viewDidLoad() {
        super.viewDidLoad()

        getRecentChats { users in
            self .recentChats.removeAll()
            for userID in users {
                Firestore.firestore().collection("Users").document(userID).getDocument { snapshot, error in
                    if error == nil {
                        if let value = snapshot?.data() {
                            if let name = value["name"] as? String {
                                self.recentChats.append(ChatUser(name: name, id: userID))
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
            
        }
        
        tableView.register(UINib(nibName: "ResentChatCell", bundle: nil), forCellReuseIdentifier: cellId)
        
    }

   
    
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentChats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ResentChatCell
        cell.usernameLabel.text = recentChats[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabBarController?.tabBar.isHidden = true
        let chatUser = ChatUser(name : recentChats[indexPath.row].name , id: recentChats[indexPath.row].id)
        performSegue(withIdentifier: "goToChatVC", sender: chatUser)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChatVC" {
            let nextVC = segue.destination as! ChatVC
            nextVC.user = sender as? ChatUser
        }
    }
  
    func getRecentChats(completion : @escaping ([String])->()) {
        Firestore.firestore().collection("Messages").addSnapshotListener { snapshot, erroe in
            if let value = snapshot?.documents {
                var tempUsers = [String]()
                for i in value {
                    let data = i.data()
                    print(data)
                    let sender = data ["sender"] as? String
                    let reciever = data["reciever"] as? String
                    guard let currentUserId = Auth.auth().currentUser?.uid else {return}
                    
                    if (sender == currentUserId) || (reciever == currentUserId) {
                        if sender != currentUserId {
                            if !tempUsers.contains(sender!) {
                                tempUsers.append(sender!)
                        }
                    }
                        if reciever != currentUserId {
                            if !tempUsers.contains(reciever!) {
                                tempUsers.append(reciever!)
                        }
                }
            }
        }
                completion(tempUsers)
    }
    
    }

   


    }
}
