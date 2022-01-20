//
//  UIViewController+Ext.swift
//  Rasha-D
//
//  Created by rasha  on 14/06/1443 AH.
//

import UIKit

extension UIViewController {
  // create string date with custom date format
    func sendDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-M-YYYY"
        let currentDate = formatter.string(from: Date())
        return currentDate
    }
    
  // create gradiant background layer
  func setGradientBackground() {
    let colorTop = UIColor(named: "topColor")?.cgColor
    let colorBottom = UIColor(named: "bottomColor")?.cgColor
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [colorTop!, colorBottom!]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame = self.view.bounds
    
    self.view.layer.insertSublayer(gradientLayer, at:0)
  }
}
