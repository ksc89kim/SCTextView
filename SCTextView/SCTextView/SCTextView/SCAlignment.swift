//
//  SCAlignment.swift
//  SCTextView
//
//  Created by kim sunchul on 2020/05/08.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import UIKit

protocol SCAlignment {
  var leftButton: UIButton? { get set }
  var rightButton: UIButton? { get set }
  var centerButton: UIButton? { get set }

  func updateAlignLeft()
  func updateAlignRight()
  func updateAlignCenter()
  func updateAlignUI(type: NSTextAlignment)

}


extension SCAlignment {

  func updateAlignLeft() {
    self.leftButton?.isSelected = true
    self.rightButton?.isSelected = false
    self.centerButton?.isSelected = false
  }

  func updateAlignRight() {
    self.leftButton?.isSelected = false
    self.rightButton?.isSelected = true
    self.centerButton?.isSelected = false
  }

  func updateAlignCenter() {
    self.leftButton?.isSelected = false
    self.rightButton?.isSelected = false
    self.centerButton?.isSelected = true
  }

  func updateAlignUI(type: NSTextAlignment) {
    switch (type) {
    case .left:
      self.updateAlignLeft()
      break
    case .center:
      self.updateAlignCenter()
      break
    case .right:
      self.updateAlignRight()
      break
    default:
      break
    }
  }
}
