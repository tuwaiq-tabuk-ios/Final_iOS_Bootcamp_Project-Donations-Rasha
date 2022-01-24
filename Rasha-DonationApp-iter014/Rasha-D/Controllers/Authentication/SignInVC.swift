//
//  ViewController.swift
//  Rasha-D
//
//  Created by rasha  on 10/05/1443 AH.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
  
  @IBOutlet weak var emailTextField: XTextField!
  @IBOutlet weak var passwordTextField: XTextField!
  @IBOutlet weak var signInButton: UIButton!
  @IBOutlet weak var errorLabel: UILabel!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    SetupUI()
    
  }
  
  
  var emailSuccess = false
  var passwordSuccess = false
  
  // MARK: - SignIn User
  @IBAction func singInButton(_ sender: UIButton) {
    
    // TextField Validation
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
    
    // check if all fields validated
    if emailSuccess == true , passwordSuccess == true {
      
      // SignIn User To Firebase
      FSUserManager.shared.signInUser(email: emailTextField.text!, password: passwordTextField.text!) { [self] error in
        if error == nil {
          errorLabel.isHidden = true
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC")
          vc?.modalPresentationStyle = .fullScreen
          vc?.modalTransitionStyle = .crossDissolve
          DispatchQueue.main.async {
            self.present(vc!, animated: true, completion: nil)
          }
        } else {
          errorLabel.isHidden = false
          errorLabel.text = FirError.Error(Code: error!._code)
        }
      } 
    }
  }
  
  
  // setUp Elements Properties
  func SetupUI() {
    emailTextField.layer.cornerRadius = 20
    passwordTextField.layer.cornerRadius = 20
    signInButton.layer.cornerRadius = 20
    
    emailTextField.backgroundColor =  .init(white: 1, alpha: 0.3)
    passwordTextField.backgroundColor = .init(white: 1, alpha: 0.3)
    
    setGradientBackground()
    
    errorLabel.isHidden = true
  }
  
  
}


