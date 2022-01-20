//
//  String+Ext.swift
//  Rasha-D
//
//  Created by rasha  on 14/06/1443 AH.
//

import Foundation

extension String {
  // return translated string depends on the device language
    func localize() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
