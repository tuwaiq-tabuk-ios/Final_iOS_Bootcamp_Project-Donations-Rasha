//
//  UserValidationVC.swift
//  Rasha-D
//
//  Created by rasha  on 16/05/1443 AH.
//

import UIKit
import Firebase

class UserValidationVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground()
        
        if Auth.auth().currentUser?.uid == nil {
            //go to sighn in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "signInVC")
            vc?.modalPresentationStyle = .fullScreen
            vc?.modalTransitionStyle = .crossDissolve
            DispatchQueue.main.async {
                self.present(vc!, animated: true, completion: nil)
            }
            
        }else{
            // go to MainVC
            print("uid : " , Auth.auth().currentUser?.uid)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC")
            vc?.modalPresentationStyle = .fullScreen
            vc?.modalTransitionStyle = .crossDissolve
            DispatchQueue.main.async {
                self.present(vc!, animated: true, completion: nil)
            }
        }
    }
}
