//
//  SCBold.swift
//  SCTextView
//
//  Created by kim sunchul on 2020/05/08.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import UIKit

protocol SCBold {
  var tempAttributedString:NSAttributedString { get set }
  var isChangeBoldUI:Bool { get set}
  var boldFont:UIFont? { get set }
  var baseFont:UIFont? { get set }
  var boldButton:UIButton?  { get set }

  func addAttributeStringForBoldStatus(attributeString: NSMutableAttributedString, range: NSRange)
}


extension SCBold {
  func addAttributeStringForBoldStatus(attributeString: NSMutableAttributedString, range: NSRange) {
    guard let sender = self.boldButton ,let bold = self.boldFont, let base = self.baseFont else {
      return
    }

    if sender.isSelected{
      attributeString.addAttribute(NSAttributedString.Key.font, value: bold, range: range)
    } else {
      attributeString.addAttribute(NSAttributedString.Key.font, value: base, range: range)
    }
  }

  func getSelectedRange(textView: UITextView) -> NSRange {
    var selectedRange = textView.selectedRange
    if selectedRange.length < 1 { // EMPTY RANGE
      selectedRange = NSRange(location: selectedRange.location - 1, length:1)
    }
    return selectedRange
  }

  func getEditAttributedString(textView: UITextView) -> NSMutableAttributedString?  {
    guard self.tempAttributedString.length <= textView.attributedText.length else {
      return nil
    }

    let editAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
    var isAfterSelectedRange = false
    self.tempAttributedString.enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, self.tempAttributedString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (value, range, stop) -> Void in
      if !isAfterSelectedRange {
        if range.intersection(self.getSelectedRange(textView: textView)) != nil{
          isAfterSelectedRange = true
        }
        editAttributedString.addAttribute(NSAttributedString.Key.font, value: value as! UIFont, range: range)
      }
    }

    self.addAttributeStringForBoldStatus(attributeString: editAttributedString, range: self.getSelectedRange(textView: textView))

    return editAttributedString
  }

  func updateBoldUI(textView: UITextView) {
    guard self.isChangeBoldUI, self.boldButton != nil else {
      return
    }

    self.tempAttributedString.enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, self.tempAttributedString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (value, range, stop) -> Void in
      let font = value as! UIFont
      if range.intersection(self.getSelectedRange(textView: textView)) != nil {
        self.boldButton?.isSelected = font.fontDescriptor.symbolicTraits.contains(.traitBold)
      }
    }
  }

}
