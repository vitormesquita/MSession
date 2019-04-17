//
//  Button.swift
//  MSession
//
//  Created by Vitor Mesquita on 10/04/19.
//

import UIKit

extension UIButton {
   
   open override var isEnabled: Bool {
      get {
         return super.isEnabled
      }
      set {
         super.isEnabled = newValue
         self.alpha = newValue ? 1.0 : 0.15
      }
   }
}
