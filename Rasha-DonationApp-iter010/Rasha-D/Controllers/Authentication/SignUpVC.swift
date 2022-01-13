//
//  SignUpVC.swift
//  Rasha-D
//
//  Created by rasha  on 10/05/1443 AH.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
  
 
  
    @IBOutlet weak var nameTextField: XTextField!
    @IBOutlet weak var emailTextField: XTextField!
    @IBOutlet weak var passwordTextField: XTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        errorLabel.alpha = 0
      
    }
    
    var nameSuccess = false
    var emailSuccess = false
    var passwordSuccess = false
 
    @IBAction func signUpAction(_ sender: UIButton) {
        if let name = nameTextField.text, name.isEmpty == false {
            nameSuccess = true
        } else {
            nameSuccess = false
            nameTextField.shakeView()
        }
        
        if let email = emailTextField.text, email.isEmpty == false {
            emailSuccess = true
        } else {
            emailSuccess = false
            emailTextField.shakeView()
        }
        
        if let password = passwordTextField.text, password.isEmpty == false {
            passwordSuccess = true
        } else {
            passwordSuccess = false
            passwordTextField.shakeView()
        }
        
        // save user to firebase
        if nameSuccess, emailSuccess, passwordSuccess {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
                if error == nil {
                    self.errorLabel.alpha = 0
                    guard let userID = result?.user.uid else {return}
                    
                    Firestore.firestore().collection("Users").document(userID).setData([
                        "name" : self.nameTextField.text!,
                        "email" : self.emailTextField.text!
                    ]) { error in
                        
                        // Go to mainVC
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC")
                        vc?.modalPresentationStyle = .fullScreen
                        vc?.modalTransitionStyle = .crossDissolve
                        DispatchQueue.main.async {
                            self.present(vc!, animated: true, completion: nil)
                        }
                    }
                } else{
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = error?.localizedDescription
                }
            }
        }
    }
    
    func setupUI() {
        
        emailTextField.backgroundColor =  .init(white: 1, alpha: 0.3)
        passwordTextField.backgroundColor = .init(white: 1, alpha: 0.3)
        nameTextField.backgroundColor = .init(white: 1, alpha: 0.3)
        
        setGradientBackground()
        
        emailTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20
        nameTextField.layer.cornerRadius = 20
        signUpButton.layer.cornerRadius = 20
    }
}
