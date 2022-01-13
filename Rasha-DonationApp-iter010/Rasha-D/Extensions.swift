//
//  Extensions.swift
//  Rasha-D
//
//  Created by rasha  on 30/05/1443 AH.
//

import UIKit
import Firebase

extension UIViewController {
    func sendDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-M-YYYY"
        let currentDate = formatter.string(from: Date())
        return currentDate
    }
    
    func setGradientBackground() {
        let colorTop = UIColor(named: "topColor")?.cgColor
        let colorBottom = UIColor(named: "bottomColor")?.cgColor 
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}


extension UIView {
    func shakeView() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.09
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))

        self.layer.add(animation, forKey: "position")
    }
}

class XTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

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

extension String {
    func localize() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
