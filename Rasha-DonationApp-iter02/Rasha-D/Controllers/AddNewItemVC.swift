//
//  AddNewItemVC.swift
//  Rasha-D
//
//  Created by rasha  on 14/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseStorage

class AddNewItemVC: UIViewController  {
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var titelTextFild: UITextField!
    
    
    @IBOutlet weak var cityTextFild: UITextField!
    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    
    @IBOutlet weak var itemImageViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        settingUpKeyboardNotifications()
        
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageAction))
        itemImageView.addGestureRecognizer(tapGesture)
        
    }
    
    var imageSuccess = false
    var ttitleSuccess = false
    var citySuccess = false
    var descriptionSuccess = false
    
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        var userName = String()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Users").document(userID).getDocument { snapshot, error in
            if error == nil {
                if let value = snapshot?.data() {
                    print(value)
                    userName = value["name"] as! String
                }
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-M-YYYY"
        let currentDate = formatter.string(from: Date())
        
        
        
        if let itemTitle = titelTextFild.text, itemTitle.isEmpty == false{
            ttitleSuccess = true
        }else {
            ttitleSuccess = false
        }
        
        if let city = cityTextFild.text, city.isEmpty == false {
            citySuccess = true
        }else{
            citySuccess = false
        }
        if let desperation = descriptionTextView.text, desperation.isEmpty == false {
            descriptionSuccess = true
        }else{
            descriptionSuccess = false
            
            
        }
        if imageSuccess,ttitleSuccess,citySuccess,descriptionSuccess {
            loadingSpinner.startAnimating()
            
            let  storageRef = Storage.storage().reference().child(UUID().uuidString)
            guard let itemImageData = itemImageView.image?.pngData() else {return}
            storageRef.putData(itemImageData, metadata: nil) { meta, error in
                if error == nil {
                    storageRef.downloadURL { [self] url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            Firestore.firestore().collection("Items").document(UUID().uuidString).setData([
                                "imageUrl" : imageUrl,
                                "title" : titelTextFild.text!,
                                "city" : cityTextFild.text!,
                                "description" : descriptionTextView.text!,
                                "username" : userName,
                                "date" : currentDate,
                                "UserID" : userID
                            ]) { error in
                                if error == nil {
                                    //return to ItemsTableView
                                    print("return to ItemsTableView")
                                    loadingSpinner.stopAnimating()
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        
    }
    
    
}

extension AddNewItemVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imageAction(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo source", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { UIAlertAction in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                //show message
                print("Camera Not Avallable")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { UIAlertAction in
            print("Photo Library")
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        itemImageView.image = selectedImage
        imageSuccess = true
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    func imagePickercontrollerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
extension AddNewItemVC {
    
    func settingUpKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        itemImageViewTop.constant = 0
        textViewHeight.constant = 80
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        itemImageViewTop.constant = 20
        textViewHeight.constant = 120
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
