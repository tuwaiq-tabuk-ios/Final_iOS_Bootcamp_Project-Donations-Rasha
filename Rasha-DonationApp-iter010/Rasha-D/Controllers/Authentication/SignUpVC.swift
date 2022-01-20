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
    @IBOutlet weak var confirmPasswordTextField: XTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    var nameSuccess = false
    var emailSuccess = false
    var passwordSuccess = false
    var confirmPasswordSuccess = false
 
  // MARK: - Save User To Firebase
  @IBAction func signUpAction(_ sender: UIButton) {
    // TextFields Validation
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
    
    if let confirmPassword = confirmPasswordTextField.text, confirmPassword.isEmpty == false {
      confirmPasswordSuccess = true
    } else {
      confirmPasswordSuccess = false
      confirmPasswordTextField.shakeView()
    }
    
    // check if all fields validated
    if nameSuccess, emailSuccess, passwordSuccess, confirmPasswordSuccess {
      
      // check if passwords are matches
      if passwordTextField.text != confirmPasswordTextField.text {
        errorLabel.isHidden = false
        errorLabel.text = "Passwords Not Match".localize()
        return
      }
      
      // save user data to firebase
      FSUserManager.shared.signUpUser(email: emailTextField.text!, password: passwordTextField.text!, name: nameTextField.text!, errorLabel: errorLabel) {
        // go to MainVC
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
          self.present(vc!, animated: true, completion: nil)
        }
      }
    }
  }
    
  // setUp Elements Properties
    func setupUI() {
        
      errorLabel.isHidden = true
      
      emailTextField.backgroundColor =  .init(white: 1, alpha: 0.3)
      passwordTextField.backgroundColor = .init(white: 1, alpha: 0.3)
      confirmPasswordTextField.backgroundColor = .init(white: 1, alpha: 0.3)
      nameTextField.backgroundColor = .init(white: 1, alpha: 0.3)
      
      setGradientBackground()
      
      emailTextField.layer.cornerRadius = 20
      passwordTextField.layer.cornerRadius = 20
      confirmPasswordTextField.layer.cornerRadius = 20
      nameTextField.layer.cornerRadius = 20
      signUpButton.layer.cornerRadius = 20
    }
}
