//
//  MainVC.swift
//  Rasha-D
//
//  Created by rasha  on 14/05/1443 AH.
//

import UIKit
import Firebase
import SDWebImage

class MainVC : UIViewController   {
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    
    var items = [Item]()
    var filterdItmes = [Item]()
    var me = String()
    var isSearching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground()
        
        me = Auth.auth().currentUser!.uid
        
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        itemsTableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "Cell")
        searchBar.delegate = self
        
        // just for test
        guard let userID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Users").document(userID).getDocument { snapshot, error in
            if error == nil {
                if let value = snapshot?.data() {
                    if let name = value["name"] as? String {
                        self.navigationItem.title = name
                        
                    }
                }
            }
        }
    }
    
    let noContentLabel : UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "No Items Here"
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = UIColor.lightGray.withAlphaComponent(0.5)
        return $0
    }(UILabel())
    
    func showContentLabel() {
        itemsTableView.addSubview(noContentLabel)
        NSLayoutConstraint.activate([
            noContentLabel.centerXAnchor.constraint(equalTo: itemsTableView.centerXAnchor),
            noContentLabel.centerYAnchor.constraint(equalTo: itemsTableView.centerYAnchor),
            noContentLabel.rightAnchor.constraint(equalTo: itemsTableView.rightAnchor),
            noContentLabel.leftAnchor.constraint(equalTo: itemsTableView.leftAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CategoryCollectionViewController.selectedCategory != "" {
            // get data for selected category
            getSpecificCategoryData()
        } else {
            getItemsData()
        }
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
        Firestore.firestore().collection("Items").order(by: "timestamp", descending: true).addSnapshotListener { [self] snapshot, error in
            if error == nil {
                self.items.removeAll()
                
                if let value = snapshot?.documents {
                    for item in value {
                        
                        let id = item.documentID
                        let data = item.data()
                        let username = data["username"] as? String
                        let title = data["title"] as? String
                        let city = data["city"] as? String
                        let date = data["date"] as? String
                        let imageUrl = data["imageUrl"] as? String
                        let description = data["description"] as? String
                        let userID = data ["userID"] as? String
                        let timestamp = data["timestamp"] as? TimeInterval
                        let category = data["category"] as? String
                        
                        self.items.append(Item(id : id, description: description, city: city, title: title, imageUrl: imageUrl, date: date, username: username, userID: userID, timestamp: timestamp, category: category))
                    }
                }
            }
            self.itemsTableView.reloadData()
            if items.count == 0 {
                showContentLabel()
            } else {
                noContentLabel.removeFromSuperview()
            }
        }
    }
    
    func getSpecificCategoryData() {
        Firestore.firestore().collection("Items").order(by: "timestamp", descending: true).addSnapshotListener { [self] snapshot, error in
            if error == nil {
                self.items.removeAll()
                if let value = snapshot?.documents {
                    for item in value {
                        let id = item.documentID
                        let data = item.data()
                        let username = data["username"] as? String
                        let title = data["title"] as? String
                        let city = data["city"] as? String
                        let date = data["date"] as? String
                        let imageUrl = data["imageUrl"] as? String
                        let description = data["description"] as? String
                        let userID = data ["userID"] as? String
                        let timestamp = data["timestamp"] as? TimeInterval
                        let category = data["category"] as? String
                        
                        if category == CategoryCollectionViewController.selectedCategory {
                            self.items.append(Item(id : id, description: description, city: city, title: title, imageUrl: imageUrl, date: date, username: username, userID: userID, timestamp: timestamp, category: category))
                        }
                    }
                }
            }
            CategoryCollectionViewController.selectedCategory = ""
            self.itemsTableView.reloadData()
            if items.count == 0 {
                showContentLabel()
            } else {
                noContentLabel.removeFromSuperview()
            }
        }
    }
    
    
}

//MARK: - SearchBar Delegate & DataSource
extension MainVC : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterdItmes.count
        } else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemCell
        
        if isSearching {
            let item = filterdItmes[indexPath.row]
            
            cell.itemLabel.text = item.title
            cell.userLabel.text = item.username
            cell.cityLabel.text = item.city
            cell.dateLabel.text = item.date
            
            if let imageUrlIsString = item.imageUrl {
                if let imageURL = URL(string: imageUrlIsString){
                    cell.itemImageView.sd_setImage(with:  imageURL) { image, error, cache, url in
                        if error == nil {
                            DispatchQueue.main.async {
                                cell.itemImageView.image = image
                            }
                        }
                    }
                }
                
            } else {
                let item = items[indexPath.row]
                cell.itemLabel.text = item.title
                cell.userLabel.text = item.username
                cell.cityLabel.text = item.city
                cell.dateLabel.text = item.date
                
                if let imgeUrlString = item.imageUrl {
                    if let imagURL = URL(string: imgeUrlString) {
                        cell.itemImageView.sd_setImage(with: imagURL)  { image , error , cache , url in
                            if error == nil {
                                DispatchQueue.main.async {
                                    cell.itemImageView.image = image
                                }
                            }
                        }
                    }
                }
                
            }
        } else {
            let item = items[indexPath.row]
            
            cell.itemLabel.text = item.title
            cell.userLabel.text = item.username
            cell.cityLabel.text = item.city
            cell.dateLabel.text = item.date
            
            
            if let imageUrlIsString = item.imageUrl {
                if let imageURL = URL(string: imageUrlIsString){
                    cell.itemImageView.sd_setImage(with:  imageURL) { image, error, cache, url in
                        if error == nil {
                            DispatchQueue.main.async {
                                cell.itemImageView.image = image
                            }
                        }
                    }
                }
                
            } else {
                let item = items[indexPath.row]
                cell.itemLabel.text = item.title
                cell.userLabel.text = item.username
                cell.cityLabel.text = item.city
                cell.dateLabel.text = item.date
                
                if let imgeUrlString = item.imageUrl {
                    if let imagURL = URL(string: imgeUrlString) {
                        cell.itemImageView.sd_setImage(with: imagURL)  { image , error , cache , url in
                            if error == nil {
                                DispatchQueue.main.async {
                                    cell.itemImageView.image = image
                                }
                            }
                        }
                    }
                }
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            performSegue(withIdentifier: "showDetailsVC", sender: filterdItmes[indexPath.row])
        } else {
            performSegue(withIdentifier: "showDetailsVC", sender: items[indexPath.row])
        }
        
        isSearching = false
        searchBar.text = ""
        view.endEditing(true)
        self.itemsTableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsVC" {
            let nextVC = segue.destination as!  itemDetailVC
            nextVC.passedItem = sender as! Item
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            alertAction(id: items[indexPath.row].id!)
        }
    }
    func alertAction(id : String) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure ! ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .destructive, handler: { action in
            Firestore.firestore().collection("Items").document(id).delete()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return items[indexPath.row].userID == me
    }
    
    
    
}


//MARK: - SearchBar Delegate
extension MainVC : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        view.endEditing(true)
        self.itemsTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearching = false
            self.itemsTableView.reloadData()
        } else {
            isSearching = true
            filterdItmes = items.filter({ item in
                return item.title!.lowercased().contains(searchText.lowercased())
            })
            self.itemsTableView.reloadData()
        }
    }
}

