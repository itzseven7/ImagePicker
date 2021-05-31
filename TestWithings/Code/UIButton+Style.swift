//
//  UIButton+Style.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import UIKit

enum UIButtonStyle {
  case primary
  
  var cornerRadius: CGFloat {
    switch self {
    case .primary:
      return 16
    }
  }
  
  var textColor: UIColor {
    switch self {
    case .primary:
      return .white
    }
  }
  
  var backgroundColor: UIColor {
    switch self {
    case .primary:
      return .blue
    }
  }
}

extension UIButton {
  func setStyle(_ style: UIButtonStyle) {
    setTitleColor(style.textColor, for: .normal)
    backgroundColor = style.backgroundColor
    layer.cornerRadius = style.cornerRadius
    layer.masksToBounds = true
  }
}
