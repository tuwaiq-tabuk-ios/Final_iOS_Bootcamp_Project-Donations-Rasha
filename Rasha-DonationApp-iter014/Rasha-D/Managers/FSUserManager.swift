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
  
  func signUpUser(email: String, password: String, name: String, completion: @escaping (Error?)->()) {
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
      if error == nil {
        guard let userID = result?.user.uid else {return}
        
        Firestore.firestore().collection(FSCollectionReference.users.rawValue).document(userID).setData([
          "name" : name,
          "email" : email
        ]) { error in
          
          // Go to mainVC
          completion(nil)
        }
      } else{
        completion(error)
      }
    }
  }
  
  
  
  func signInUser(email: String, password: String, completion: @escaping (Error?)->()) {
    Auth.auth().signIn(withEmail: email, password: password) { result, error in
        if error == nil {
            //go to mainVC
            completion(nil)
        } else {
            //handle error by show error massage
          completion(error)
        }
    }
  }
  
}



