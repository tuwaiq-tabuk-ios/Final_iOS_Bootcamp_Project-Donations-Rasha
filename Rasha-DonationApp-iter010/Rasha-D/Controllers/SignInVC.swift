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
    
    var emaileSuccess = false
    var passwoordSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.backgroundColor =  .init(white: 1, alpha: 0.3)
        passwordTextField.backgroundColor = .init(white: 1, alpha: 0.3)
        
        setGradientBackground()
        SetupUI()
        errorLabel.alpha = 0
 
    }
    
    
    @IBAction func singInButton(_ sender: UIButton) {
        
        if let email = emailTextField.text, email.isEmpty == false {
            emaileSuccess = true
        } else {
            emaileSuccess = false
            emailTextField.shakeView()
        }
        
        
        if let password = passwordTextField.text, password.isEmpty == false {
            passwoordSuccess = true
        } else {
            passwoordSuccess = false
            passwordTextField.shakeView()
        }
        
        if emaileSuccess == true , passwoordSuccess == true {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
                if error == nil {
                    self.errorLabel.alpha = 0
                    //go to mainVc
                    print("go to MainVC")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC")
                    vc?.modalPresentationStyle = .fullScreen
                    vc?.modalTransitionStyle = .crossDissolve
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    //handle error by show error massage
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = FirError.Error(Code: error!._code) //error?.localizedDescription
                }
            }
        }
    }
    
    
    
    func SetupUI() {
        emailTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20
        signInButton.layer.cornerRadius = 20
    }
    
    
}


