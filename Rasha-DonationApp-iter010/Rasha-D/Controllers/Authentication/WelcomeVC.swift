//
//  UserValidationVC.swift
//  Rasha-D
//
//  Created by rasha  on 16/05/1443 AH.
//

import UIKit
import Firebase

class WelcomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground()
      
      /*
       check :
       if currentUser ID = nil -> Go To SignInVC
       if currentUser ID != nil -> Go To MainVC
       */
        
        if Auth.auth().currentUser?.uid == nil {
            // Go To Sign In
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "signInVC")
            vc?.modalPresentationStyle = .fullScreen
            vc?.modalTransitionStyle = .crossDissolve
            DispatchQueue.main.async {
                self.present(vc!, animated: true, completion: nil)
            }
            
        }else{
            // Go To MainVC
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC")
            vc?.modalPresentationStyle = .fullScreen
            vc?.modalTransitionStyle = .crossDissolve
            DispatchQueue.main.async {
                self.present(vc!, animated: true, completion: nil)
            }
        }
    }
}
