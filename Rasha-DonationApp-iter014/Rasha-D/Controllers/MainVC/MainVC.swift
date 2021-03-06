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
        
    }
    
  // show no content label in tableView
    let noContentLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Items Here".localize()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.lightGray.withAlphaComponent(0.5)
        return label
    }()
    
  // add no content label to itemsTableView
    func showContentLabel() {
        itemsTableView.addSubview(noContentLabel)
        
        NSLayoutConstraint.activate([
        noContentLabel.centerXAnchor.constraint(equalTo: itemsTableView.centerXAnchor),
            noContentLabel.centerYAnchor.constraint(equalTo: itemsTableView.centerYAnchor),
            noContentLabel.rightAnchor.constraint(equalTo: itemsTableView.rightAnchor),
            noContentLabel.leftAnchor.constraint(equalTo: itemsTableView.leftAnchor)
        ])
    }
    
  // get items from firestore depends on categoryVC Collection
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CategoryCollectionVC.selectedCategory != "" {
            // get data for selected category
            getSpecificCategoryData()
        } else {
            getItemsData()
        }
    }
    
  // sign out from firestore and go to signInVC
    @IBAction func exetButtonAction(_ sender: UIBarButtonItem) {
        try?  Auth.auth().signOut()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "signInVC")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            self.present(vc!, animated: true, completion: nil)
        }
        
        
    }
    
  // get all items data
    func getItemsData() {
      Firestore.firestore().collection(FSCollectionReference.items.rawValue).order(by: "timestamp", descending: true).addSnapshotListener { [self] snapshot, error in
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
    
  // get items data for specific category
    func getSpecificCategoryData() {
      Firestore.firestore().collection(FSCollectionReference.items.rawValue).order(by: "timestamp", descending: true).addSnapshotListener { [self] snapshot, error in
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
                        
                        if category == CategoryCollectionVC.selectedCategory {
                            self.items.append(Item(id : id, description: description, city: city, title: title, imageUrl: imageUrl, date: date, username: username, userID: userID, timestamp: timestamp, category: category))
                        }
                    }
                }
            }
            CategoryCollectionVC.selectedCategory = ""
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

      /*
       item variable will hold items value depends on isSearching Bool status
        - if isSearching == true -> item = filterdItmes[indexPath.row]
        - else item = items[indexPath.row]
       */
      
      let item = isSearching == true ? filterdItmes[indexPath.row] : items[indexPath.row]
      
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
          
      }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
          performSegue(withIdentifier: SegueIdentifires.showDetailsVC, sender: filterdItmes[indexPath.row])
        } else {
            performSegue(withIdentifier: SegueIdentifires.showDetailsVC, sender: items[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifires.showDetailsVC {
            let nextVC = segue.destination as! itemDetailVC
            nextVC.passedItem = sender as? Item
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
        let alert = UIAlertController(title: "Alert".localize(), message: "Are you sure ! ".localize(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localize(), style: .destructive, handler: { action in
          Firestore.firestore().collection(FSCollectionReference.items.rawValue).document(id).delete()
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      print("textDidChange")
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

