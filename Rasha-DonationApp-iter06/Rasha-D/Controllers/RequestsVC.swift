//
//  RequestsVC.swift
//  Rasha-D
//
//  Created by rasha  on 29/05/1443 AH.
//

import UIKit
import Firebase

class RequestsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var requestsTableView : UITableView!

    var requests = [Request]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestsTableView.delegate = self
        requestsTableView.dataSource = self
        requestsTableView.register(UINib(nibName: "RequestCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        getAllRequests()
    }
    
    func getAllRequests() {
        Firestore.firestore().collection("Requests").order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
            self.requests.removeAll()
            if error == nil {
                if let value = snapshot?.documents {
                    for i in value {
                        let data = i.data()
                        let requestText = data["requestText"] as? String
                        let requestID = data["requestID"] as? String
                        let userID = data["userID"] as? String
                        let date = data["date"] as? String
                        let city = data["city"] as? String
                        
                        let request = Request(requestID: requestID, userID: userID, requestText: requestText, date: date, city: city)
                        
                        self.requests.append(request)
                    }
                    self.requestsTableView.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = requestsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RequestCell
        
        let request = requests[indexPath.row]
        cell.requestTextLabel.text = request.requestText
        cell.cityLabel.text = request.city
        cell.dateLabel.text = request.date
        return cell
    }
    

    

}
