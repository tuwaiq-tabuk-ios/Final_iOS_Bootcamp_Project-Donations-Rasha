//
//  Extensions.swift
//  Rasha-D
//
//  Created by rasha  on 30/05/1443 AH.
//

import UIKit
import Firebase

//MARK: - Convert Fierbase Errors To Readable Phrase For Users Depends On Error Code
class FirError {
    static func Error(Code : Int) -> String {
        
        if let TheError = AuthErrorCode(rawValue: Code) {
            
            switch TheError {
            case .emailAlreadyInUse :
                return "Mail is already in use ".localize()
            case .weakPassword :
                return " weak password ".localize()
            case .networkError :
                return  "Check network connection ".localize()
            case .userNotFound :
                return  "  Account not found ".localize()
            case .invalidEmail :
                return " wrong email ".localize()
            case .wrongPassword :
                return " wrong password ".localize()
            default :
                return " unknown error ".localize()
            }
        }
        return " unknown error ".localize()
    }
}


