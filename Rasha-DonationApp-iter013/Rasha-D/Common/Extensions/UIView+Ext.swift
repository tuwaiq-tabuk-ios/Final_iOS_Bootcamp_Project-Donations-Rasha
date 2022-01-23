//
//  UIView+Ext.swift
//  Rasha-D
//
//  Created by rasha  on 14/06/1443 AH.
//

import UIKit

extension UIView {
  // create UIView shake animation 
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
