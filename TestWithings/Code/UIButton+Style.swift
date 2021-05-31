//
//  UIButton+Style.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import UIKit

enum UIButtonStyle {
  case primary
  case secondary
  
  var cornerRadius: CGFloat {
    switch self {
    case .primary:
      return 16
    case .secondary:
      return 9
    }
  }
  
  var textColor: UIColor {
    switch self {
    case .primary:
      return .white
    case .secondary:
      return .primary
    }
  }
  
  var backgroundColor: UIColor {
    switch self {
    case .primary:
      return .primary
    case .secondary:
      return .white
    }
  }
  
  var borderWidth: CGFloat {
    switch self {
    case .primary:
      return 0
    case .secondary:
      return 3
    }
  }
  
  var borderColor: CGColor? {
    switch self {
    case .primary:
      return nil
    case .secondary:
      return UIColor.primary.cgColor
    }
  }
  
  func textColorForState(_ state: UIControl.State) -> UIColor? {
    switch self {
    case .primary:
      switch state {
      case .normal, .selected, .highlighted:
        return .white
      case .disabled:
        return .lightGray
      default:
        return nil
      }
    case .secondary:
      switch state {
      case .normal, .selected:
        return .primary
      case .highlighted:
        return .blue
      case .disabled:
        return .lightGray
      default:
        return nil
      }
    }
  }
  
  func backgroundImageForState(_ state: UIControl.State) -> UIImage? {
    switch self {
    case .primary:
      switch state {
      case .normal, .selected:
        return UIImage(color: .primary)
      case .highlighted:
        return UIImage(color: .highlighted)
      case .disabled:
        return UIImage(color: .disabled)
      default:
        return nil
      }
    case .secondary:
      switch state {
      case .normal, .selected, .highlighted:
        return UIImage(color: .white)
      case .disabled:
        return UIImage(color: .disabled)
      default:
        return nil
      }
    }
  }
}

extension UIButton {
  func setStyle(_ style: UIButtonStyle) {
    setTitleColor(style.textColor, for: .normal)
    
    [UIControl.State.normal, UIControl.State.selected, UIControl.State.highlighted, UIControl.State.disabled].forEach {
      setBackgroundImage(style.backgroundImageForState($0), for: $0)
    }
    
    layer.cornerRadius = style.cornerRadius
    layer.masksToBounds = true
    layer.borderWidth = style.borderWidth
    layer.borderColor = style.borderColor
  }
}
