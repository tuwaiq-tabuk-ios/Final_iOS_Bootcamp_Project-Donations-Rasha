//
//  ResentChatVC.swift
//  Rasha-D
//
//  Created by rasha  on 23/05/1443 AH.
//

import UIKit
import Firebase

class ResentChatVC: UITableViewController {
    let cellId = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()

        getRecentChats()
        
        tableView.register(UINib(nibName: "ResentChatCell", bundle: nil), forCellReuseIdentifier: cellId)
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ResentChatCell
        cell.usernameLabel.text = "Rasha"
        return cell
    }
  
    func getRecentChats() {
        Firestore.firestore().collection("Messages").addSnapshotListener { snapshot, erroe in
            if let value = snapshot?.documents {
                for i in value {
                    let data = i.data()
                    print(data)
                }
            }
        }
    }
    
    }

   


