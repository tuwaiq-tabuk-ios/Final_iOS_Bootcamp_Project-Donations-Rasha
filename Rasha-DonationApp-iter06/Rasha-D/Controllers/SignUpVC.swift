//
//  SignUpVC.swift
//  Rasha-D
//
//  Created by rasha  on 10/05/1443 AH.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
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
            nameTextField.addShadow(shadowColor: .darkGray)
        } else {
            nameSuccess = false
            nameTextField.addShadow(shadowColor: .red)
        }
        
        if let email = emailTextField.text, email.isEmpty == false {
            emailSuccess = true
            emailTextField.addShadow(shadowColor: .darkGray)
        } else {
            emailSuccess = false
            emailTextField.addShadow(shadowColor: .red)
        }
        
        if let password = passwordTextField.text, password.isEmpty == false {
            passwordSuccess = true
            passwordTextField.addShadow(shadowColor: .darkGray)
        } else {
            passwordSuccess = false
            passwordTextField.addShadow(shadowColor: .red)
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
                }else{
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = error?.localizedDescription
                }
            }
        }
    }
    
    func setupUI() {
        nameTextField.addShadow(shadowColor: .darkGray)
        emailTextField.addShadow(shadowColor: .darkGray)
        passwordTextField.addShadow(shadowColor: .darkGray)
        
        
        emailTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20
        nameTextField.layer.cornerRadius = 20
        signUpButton.layer.cornerRadius = 20
        
    }
    
    
    
}

extension UIView {
    func addShadow(shadowColor: UIColor,
                   shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0),
                   shadowOpacity: Float = 1.0,
                   shadowRadius: CGFloat = 5.0) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
}
