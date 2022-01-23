//
//  FSUserManager.swift
//  Rasha-D
//
//  Created by rasha  on 15/06/1443 AH.
//

import UIKit
import Firebase

class FSUserManager {
  
  static var shared = FSUserManager()
  
  func signUpUser(email: String, password: String, name: String, errorLabel : UILabel, completion: @escaping ()->()) {
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
      if error == nil {
        errorLabel.isHidden = true
        guard let userID = result?.user.uid else {return}
        
        Firestore.firestore().collection(FSCollectionReference.users.rawValue).document(userID).setData([
          "name" : name,
          "email" : email
        ]) { error in
          
          // Go to mainVC
          completion()
        }
      } else{
        errorLabel.isHidden = false
        errorLabel.text = FirError.Error(Code: error!._code)
      }
    }
  }
  
  
  func signInUser(email: String, password: String, errorLabel : UILabel, completion: @escaping ()->()) {
    Auth.auth().signIn(withEmail: email, password: password) { result, error in
        if error == nil {
            errorLabel.isHidden = true
            //go to mainVC
            completion()
        } else {
            //handle error by show error massage
            errorLabel.isHidden = false
            errorLabel.text = FirError.Error(Code: error!._code)
        }
    }
  }
  
}



