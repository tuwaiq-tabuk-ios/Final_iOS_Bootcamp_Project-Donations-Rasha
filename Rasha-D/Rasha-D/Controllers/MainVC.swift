//
//  MainVC.swift
//  Rasha-D
//
//  Created by rasha  on 14/05/1443 AH.
//

import UIKit
import Firebase

class MainVC : UIViewController   {

    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        itemsTableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "Cell")
        getItemsData()
    }
    
    @IBAction func exetButtonAction(_ sender: UIBarButtonItem) {
      try?  Auth.auth().signOut()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "signInVC")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            self.present(vc!, animated: true, completion: nil)
        }
        
        
    }
    
    func getItemsData() {
        Firestore.firestore().collection("Items").addSnapshotListener { snapshot, error in
            if error == nil {
                self.items.removeAll()
                
                if let value = snapshot?.documents {
                    for item in value {
                        let data = item.data()
                       let username = data["username"] as? String
                        let title = data["title"] as? String
                        let city = data["city"] as? String
                        let date = data["date"] as? String
                        let imageUrl = data["imageUrl"] as? String
                        let description = data["description"] as? String
                        self.items.append(Item(description: description, city: city, title: title, imageUrl: imageUrl, date: date, username: username))
                    }
                }
            }
            self.itemsTableView.reloadData()
        }
    }
    
    
}
    extension MainVC : UITableViewDataSource , UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemCell
        let item = items[indexPath.row]
        
        cell.itemLabel.text = item.title
        cell.userLabel.text = item.username
        cell.cityLabel.text = item.city
        cell.dateLabel.text = item.date
        
        
       if let imageUrlIsString = item.imageUrl {
           if let imageURL = URL(string: imageUrlIsString){
               URLSession.shared.dataTask(with: imageURL) { data, response, error in
                   if error == nil {
                       print("DATA : " , data)
                       DispatchQueue.main.async {
                           cell.itemImageView.image = UIImage(data: data!)
                       }
                   }
               }.resume()
           }
            
        }
        
        
        

        return cell
        
    }


        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(items[indexPath.row])
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    }
