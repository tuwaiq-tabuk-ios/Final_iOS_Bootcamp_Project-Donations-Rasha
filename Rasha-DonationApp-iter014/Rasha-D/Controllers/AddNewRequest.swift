//
//  AddNewRequest.swift
//  Rasha-D
//
//  Created by rasha  on 28/05/1443 AH.
//

import UIKit
import Firebase

class AddNewRequest: UIViewController {
    
  // MARK: - BOutlet
  
    @IBOutlet weak var descriptionView : UIView!
    @IBOutlet weak var descriptionTextView : UITextView!
    @IBOutlet weak var cityTextField : XTextField!
    @IBOutlet weak var addRequestButton : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground()
      
        cityTextField.backgroundColor = .init(white: 1, alpha: 0.3)
        descriptionView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.cornerRadius = 8
        addRequestButton.layer.cornerRadius = 22.5
        cityTextField.layer.cornerRadius = 20
        
        descriptionTextView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    var descriptionSuccess = false
    var citySuccess = false
    @IBAction func sendButtonAction(_ sender : UIButton) {
        if let description = descriptionTextView.text, description.isEmpty == false {
            descriptionSuccess = true
            descriptionView.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            descriptionSuccess = false
            descriptionView.layer.borderColor = UIColor.red.cgColor
        }
        
        
        if let city = cityTextField.text, city.isEmpty == false {
            citySuccess = true
            cityTextField.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            citySuccess = false
            cityTextField.layer.borderColor = UIColor.red.cgColor
        }
        
        if descriptionSuccess, citySuccess {
            
            let requestID = UUID().uuidString
            guard let userID = Auth.auth().currentUser?.uid else {return}
            Firestore.firestore().collection(FSCollectionReference.requests.rawValue).document(requestID).setData([
                "requestID" : requestID,
                "userID" : userID,
                "requestText" : descriptionTextView.text!,
                "date" : sendDate(),
                "timestamp" : Date().timeIntervalSince1970,
                "city" : cityTextField.text!
            ]) { error in
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        
        
    }
    
}

extension AddNewRequest : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Request Description".localize() {
            textView.text = ""
            textView.textColor = .darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let trimmed = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        textView.text = trimmed
        if textView.text == "" {
            textView.text = "Request Description".localize()
            textView.textColor = .lightGray
        }
    }
}
