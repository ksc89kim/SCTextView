//
//  SCTextView.swift
//  SCTextView
//
//  Created by kim sunchul on 2019. 1. 26..
//  Copyright © 2019년 kim sunchul. All rights reserved.
//

import UIKit

@objc protocol SCTextViewDelegate: AnyObject {
  @objc optional func scTextViewShouldBeginEditing(_ textView: UITextView) -> Bool
  @objc optional func scTextViewShouldEndEditing(_ textView: UITextView) -> Bool
  @objc optional func scTextViewDidChange(_ textView: UITextView)
  @objc optional func scTextViewDidChangeSelection(_ textView: UITextView)
  @objc optional func scTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
  @objc optional func scTextView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
}

final class SCTextView: UIView, SCAlignment, SCBold {

  // MARK: - UI Components

  @IBOutlet var view: UIView!
  @IBOutlet weak var textView: UITextView!

  // MARK: - Properties

  weak var delegate:SCTextViewDelegate?

  // MARK: - SCBold

  var boldFont: UIFont?
  var baseFont: UIFont?
  var tempAttributedString: NSAttributedString = NSAttributedString(string: "")
  var isChangeBoldUI: Bool = false
  weak var boldButton: UIButton? {
    didSet{
      self.boldButton?.addTarget(self, action: #selector(self.onBold(sender:)), for: .touchUpInside)
    }
  }

  // MARK: - SCAlignment

  weak var leftButton: UIButton? {
    didSet {
      self.leftButton?.addTarget(self, action: #selector(self.onLeft(sender:)), for: .touchUpInside)
    }
  }

  weak var rightButton: UIButton? {
    didSet {
      self.rightButton?.addTarget(self, action: #selector(self.onRight(sender:)), for: .touchUpInside)
    }
  }

  weak var centerButton: UIButton? {
    didSet {
      self.centerButton?.addTarget(self, action: #selector(self.onCenter(sender:)), for: .touchUpInside)
    }
  }

  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    self.setup()
  }

  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    self.setup()
  }

  // MARK: - Set

  func setup() {
    self.setUI()
    self.setEvent()
  }

  func setUI() {
    let bundle = Bundle(for: self.classForCoder)
    let nib = UINib(nibName: String(describing: SCTextView.self), bundle: bundle)
    self.view =  nib.instantiate(withOwner: self, options: nil).first as? UIView
    self.addSubview(self.view);
    self.setBaseConstraint(view: self.view)
  }

  func setEvent() {
    self.textView.delegate = self
  }

  // MARK: - Event

  @objc func onBold(sender: UIButton) {
    sender.toggle()

    let editAttributedString = NSMutableAttributedString(attributedString: self.textView.attributedText)
    self.addAttributeStringForBoldStatus(attributeString: editAttributedString, range: self.textView.selectedRange)
    self.setTextViewAttributeString(attributeString:editAttributedString , selectedTextRange: self.textView.selectedTextRange)
  }

  @objc func onLeft(sender: UIButton) {
    self.textView.textAlignment = .left
    self.updateAlignUI(type:textView.textAlignment)
  }

  @objc func onRight(sender: UIButton) {
    self.textView.textAlignment = .right
    self.updateAlignUI(type:textView.textAlignment)
  }

  @objc func onCenter(sender: UIButton) {
    self.textView.textAlignment = .center
    self.updateAlignUI(type:textView.textAlignment)
  }

  func setTextViewAttributeString(attributeString: NSMutableAttributedString, selectedTextRange: UITextRange?) {
    self.textView.attributedText = attributeString
    self.tempAttributedString = self.textView.attributedText
    if selectedTextRange != nil {
      self.textView.selectedTextRange = selectedTextRange
    }
  }
}


extension SCTextView: UITextViewDelegate{
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    return self.delegate?.scTextViewShouldBeginEditing?(textView) ?? true
  }

  func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    return self.delegate?.scTextViewShouldEndEditing?(textView) ?? true
  }

  func textViewDidChange(_ textView: UITextView) {
    guard self.boldButton != nil else {
      return
    }
    
    if let editAttributedString = getEditAttributedString(textView: textView) {
      self.setTextViewAttributeString(attributeString:editAttributedString , selectedTextRange:textView.selectedTextRange)
    } else {
      self.setTextViewAttributeString(attributeString:NSMutableAttributedString(attributedString: textView.attributedText) , selectedTextRange:nil)
    }

    self.isChangeBoldUI = true
    self.delegate?.scTextViewDidChange?(textView)
  }

  func textViewDidChangeSelection(_ textView: UITextView) {
    self.updateBoldUI(textView: textView)
    delegate?.scTextViewDidChangeSelection?(textView)
  }

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    self.isChangeBoldUI = false
    return delegate?.scTextView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
  }

  func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    return self.delegate?.scTextView?(textView,shouldInteractWith:textAttachment,in:characterRange,interaction:interaction) ?? true
  }
}
