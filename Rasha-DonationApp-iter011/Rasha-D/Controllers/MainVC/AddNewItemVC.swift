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
    @IBOutlet weak var cityNameButton: UIButton!
    @IBOutlet weak var itemImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var categoryNameButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    
    @IBAction func categoryButtonAction(_ sender: UIButton) {
      performSegue(withIdentifier: SegueIdentifires.showCitiesAndCategories, sender: "category")
    }
    
    
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextFild.isHidden = true
        descriptionTextView.delegate = self
        
        titelTextFild.backgroundColor = .init(white: 1, alpha: 0.3)
        cityTextFild.backgroundColor = .init(white: 1, alpha: 0.3)
        cityNameButton.backgroundColor = .init(white: 1, alpha: 0.3)
        categoryNameButton.backgroundColor = .init(white: 1, alpha: 0.3)
        cityNameButton.layer.cornerRadius = 20
        categoryNameButton.layer.cornerRadius = 20
        titelTextFild.layer.cornerRadius = 20
        cityTextFild.layer.cornerRadius = 20
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 5
        sendButton.layer.cornerRadius = 22.5
        
        setGradientBackground()
        
        
        settingUpKeyboardNotifications()
        
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageAction))
        itemImageView.addGestureRecognizer(tapGesture)
        
        
    }
    
    @IBAction func cityButtonAction(_ sender: Any) {
        
        
      performSegue(withIdentifier: SegueIdentifires.showCitiesAndCategories, sender: "city".localize())
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifires.showCitiesAndCategories {
            let destination = segue.destination as! citiesAndCategoriesVC
            destination.delegate = self
            destination.selectedButton = sender as! String
        }
    }
    
    
    var imageSuccess = false
    var titleSuccess = false
    var citySuccess = false
    var descriptionSuccess = false
    var categorySuccess = false
    
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
            titleSuccess = true
        }else {
            titleSuccess = false
            titelTextFild.shakeView()
        }
        
        
        var selectedCity = String()
        
        if cityNameButton.titleLabel?.text == "Choos City".localize() {
            citySuccess = false
        }
        else {
            if cityNameButton.titleLabel?.text == "other".localize() {
                if let city = cityTextFild.text, city.isEmpty == false {
                    citySuccess = true
                    selectedCity = cityTextFild.text!
                } else {
                    citySuccess = false
                    cityTextFild.shakeView()
                }
            }
            else {
                citySuccess = true
                selectedCity = (cityNameButton.titleLabel?.text)!
            }
        }
        
        
        if categoryNameButton.titleLabel?.text == "Choose Category".localize() {
            categorySuccess = false
            cityTextFild.shakeView()
        } else {
            categorySuccess = true
        }
        
        
        
        
        if let description = descriptionTextView.text, description.isEmpty == false {
            descriptionSuccess = true
        } else {
            descriptionSuccess = false
        }
        

        
        if imageSuccess,titleSuccess,citySuccess, categorySuccess, descriptionSuccess {
            loadingSpinner.startAnimating()
            
            let storageRef = Storage.storage().reference().child(UUID().uuidString)
            guard let itemImageData = itemImageView.image?.pngData() else {return}
            let timestamp = Date().timeIntervalSince1970
            storageRef.putData(itemImageData, metadata: nil) { meta, error in
                if error == nil {
                    storageRef.downloadURL { [self] url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            Firestore.firestore().collection("Items").document(UUID().uuidString).setData([
                                "imageUrl" : imageUrl,
                                "title" : titelTextFild.text!,
                                "city" : selectedCity,
                                "description" : descriptionTextView.text!,
                                "username" : userName,
                                "date" : currentDate,
                                "userID" : userID ,
                                "timestamp" : timestamp,
                                "category" : categoryNameButton.titleLabel?.text!
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
        
        let actionSheet = UIAlertController(title: "Photo source".localize(), message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera".localize(), style: .default, handler: { UIAlertAction in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                //show message
                print("Camera Not Available")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library".localize(), style: .default, handler: { UIAlertAction in
            print("Photo Library")
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: { UIAlertAction in}))
        
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

extension AddNewItemVC : CitiesAndCategoriesVCDelegate {
    func pickerSelectedRow(name: String, selectedButton: String) {
        if selectedButton == "city".localize() {
            cityNameButton.setTitle(name, for: .normal)
            cityNameButton.tintColor = Colors.darkGrayWhite
            if name == "other".localize() {
                cityTextFild.isHidden = false
                cityNameButton.tintColor = Colors.lightGrayWhite
            } else {
                cityTextFild.isHidden = true
            }
        } else {
            categoryNameButton.setTitle(name, for: .normal)
            categoryNameButton.tintColor = Colors.darkGrayWhite
        }
    }
}


extension AddNewItemVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Item's description".localize() {
            textView.text = ""
            textView.textColor = Colors.darkGrayWhite
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let trimmed = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        textView.text = trimmed
        if textView.text == "" {
            textView.text = "Item's description".localize()
            textView.textColor = Colors.lightGrayWhite
        }
    }
}
