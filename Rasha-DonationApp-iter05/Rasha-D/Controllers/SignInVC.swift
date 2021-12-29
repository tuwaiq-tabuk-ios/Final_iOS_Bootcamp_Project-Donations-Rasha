//
//  ViewController.swift
//  Rasha-D
//
//  Created by rasha  on 10/05/1443 AH.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var emaileSuccess = false
    var passwoordSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupUI()
        
        emailTextField.leftView?.frame = CGRect(x: 0, y: 0, width: emailTextField.frame.width - 20, height: emailTextField.frame.height)
    }
    
    
    @IBAction func singInButton(_ sender: UIButton) {
        
        if let email = emailTextField.text, email.isEmpty == false {
            emaileSuccess = true
            emailTextField.addShadow(shadowColor: .darkGray)
        } else {
            emaileSuccess = false
            emailTextField.addShadow(shadowColor: .red)
        }
        if let email = passwordTextField.text, email.isEmpty == false {
            passwoordSuccess = true
            passwordTextField.addShadow(shadowColor: .darkGray)
        } else {
            passwoordSuccess = false
            passwordTextField.addShadow(shadowColor: .red)
            
            
        }
        if emaileSuccess == true , passwoordSuccess == true {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
                if error == nil {
                    //go to mainVc
                    print("go to MainVC")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC")
                    vc?.modalPresentationStyle = .fullScreen
                    vc?.modalTransitionStyle = .crossDissolve
                    self.present(vc!, animated: true, completion: nil)
                }else {
                    //handle error by show error massage
                    print("handel error by show error massage")
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    
    
    func SetupUI() {
        emailTextField.addShadow(shadowColor: .darkGray)
        passwordTextField.addShadow(shadowColor:.darkGray)
        
        
        emailTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20
        signInButton.layer.cornerRadius = 20
        
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
//        emailTextField.leftView = paddingView
//        emailTextField.leftViewMode = .always
    }
    
    
}


