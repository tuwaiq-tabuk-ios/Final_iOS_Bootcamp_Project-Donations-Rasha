//
//  Extensions.swift
//  Rasha-D
//
//  Created by rasha  on 30/05/1443 AH.
//

import UIKit

extension UIViewController {
    func sendDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-M-YYYY"
        let currentDate = formatter.string(from: Date())
        return currentDate
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 0.00, green: 0.42, blue: 0.46, alpha: 1.00).withAlphaComponent(0.3).cgColor
        let colorBottom = UIColor(red: 0.00, green: 0.42, blue: 0.46, alpha: 1.00).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}


