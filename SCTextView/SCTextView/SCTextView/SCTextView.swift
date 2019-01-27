//
//  SCTextView.swift
//  SCTextView
//
//  Created by kim sunchul on 2019. 1. 26..
//  Copyright © 2019년 kim sunchul. All rights reserved.
//

import UIKit

extension UIView {
    func setBaseConstraint(view:UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let viewWidth = NSLayoutConstraint(item: view,
                                           attribute: .width,
                                           relatedBy: .equal,
                                           toItem: self,
                                           attribute: .width,
                                           multiplier: 1,
                                           constant: 0)
        
        let viewHeight = NSLayoutConstraint(item: view,
                                           attribute: .height,
                                           relatedBy: .equal,
                                           toItem: self,
                                           attribute: .height,
                                           multiplier: 1,
                                           constant: 0)
        
        let centerX = NSLayoutConstraint(item: view,
                                        attribute: .centerX,
                                        relatedBy: .equal,
                                        toItem: self,
                                        attribute: .centerX,
                                        multiplier: 1,
                                        constant: 0)
        
        let centerY = NSLayoutConstraint(item: view,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        
        self.addConstraints([viewWidth,viewHeight,centerX,centerY])
    }
}

@objc protocol SCTextViewDelegate:class {
    @objc optional func scTextViewShouldBeginEditing(_ textView: UITextView) -> Bool
    @objc optional func scTextViewShouldEndEditing(_ textView: UITextView) -> Bool
    @objc optional func scTextViewDidChange(_ textView: UITextView)
    @objc optional func scTextViewDidChangeSelection(_ textView: UITextView)
    @objc optional func scTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    @objc optional func scTextView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
}

class SCTextView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var textView: UITextView!
    
    var attributedText: NSAttributedString! = NSAttributedString(string: "")
    var isChangeBoldButton:Bool = false
    var boldFont:UIFont?
    var baseFont:UIFont?
    weak var delegate:SCTextViewDelegate?
    
    weak var boldButton:UIButton? {
        didSet{
            boldButton?.addTarget(self, action: #selector(onBold(sender:)), for: .touchUpInside)
        }
    }
    
    weak var leftButton:UIButton? {
        didSet {
            leftButton?.addTarget(self, action: #selector(onLeft(sender:)), for: .touchUpInside)
        }
    }
    
    weak var rightButton:UIButton? {
        didSet {
            rightButton?.addTarget(self, action: #selector(onRight(sender:)), for: .touchUpInside)
        }
    }
    
    weak var centerButton:UIButton? {
        didSet {
            centerButton?.addTarget(self, action: #selector(onCenter(sender:)), for: .touchUpInside)
        }
    }

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
    
    func setup() {
        self.setUI()
        self.setEvent()
    }
    
    func setUI() {
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: String(describing: SCTextView.self), bundle: bundle)
        self.view =  nib.instantiate(withOwner: self, options: nil).first as? UIView
        self.setBaseConstraint(view: self.view)
        self.addSubview(view);
    }
    
    func setEvent() {
        textView.delegate = self
    }
    
    @objc func onBold(sender:UIButton) {
        self.checkButton(sender: sender)
        let theAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        addAttributeString(isBold: sender.isSelected, attributeString: theAttributedString, range: textView.selectedRange)
        setTextViewAttributeString(attributeString:theAttributedString , selectedTextRange: textView.selectedTextRange)
    }
    
    @objc func onLeft(sender:UIButton) {
        textView.textAlignment = .left
        updateAlignButton()
    }
    
    @objc func onRight(sender:UIButton) {
        textView.textAlignment = .right
        updateAlignButton()
    }
    
    @objc func onCenter(sender:UIButton) {
        textView.textAlignment = .center
        updateAlignButton()
    }
    
    func checkButton(sender:UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    func updateAlignButton() {
        switch (textView.textAlignment) {
        case .left:
            leftButton?.isSelected = true
            rightButton?.isSelected = false
            centerButton?.isSelected = false
            break
        case .center:
            leftButton?.isSelected = false
            rightButton?.isSelected = false
            centerButton?.isSelected = true
            break
        case .right:
            leftButton?.isSelected = false
            rightButton?.isSelected = true
            centerButton?.isSelected = false
            break
        default:
            break
        }
    }
    
    func getSelectRange() -> NSRange {
        var selectedRange = textView.selectedRange
        if selectedRange.length < 1 { //셀렉트된 글이 없을 경우.
            selectedRange = NSRange(location: selectedRange.location - 1, length:1)
        }
        return selectedRange
    }
    
    func setTextViewAttributeString(attributeString:NSMutableAttributedString, selectedTextRange:UITextRange?){
        textView.attributedText = attributeString
        self.attributedText = textView.attributedText
        if selectedTextRange != nil {
            textView.selectedTextRange = selectedTextRange
        }
    }
    
    func addAttributeString(isBold:Bool, attributeString:NSMutableAttributedString, range:NSRange) {
        guard let bold = boldFont, let base = baseFont else {
            return;
        }
        
        if isBold {
            attributeString.addAttribute(NSAttributedString.Key.font, value: bold, range: range)
        } else {
            attributeString.addAttribute(NSAttributedString.Key.font, value: base, range: range)
        }
    }
 
}

extension SCTextView: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return delegate?.scTextViewShouldBeginEditing?(textView) ?? true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return delegate?.scTextViewShouldEndEditing?(textView) ?? true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let button = boldButton else {
            return;
        }
        
        let theAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        if attributedText.length <= theAttributedString.length {
            var isAfterRange = false
            attributedText.enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, attributedText.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (value, range, stop) -> Void in
                if range.intersection(getSelectRange()) != nil {
                    isAfterRange = true
                    theAttributedString.addAttribute(NSAttributedString.Key.font, value: value as! UIFont, range: range)
                } else if !isAfterRange {
                    theAttributedString.addAttribute(NSAttributedString.Key.font, value: value as! UIFont, range: range)
                }
            }
            addAttributeString(isBold: button.isSelected, attributeString: theAttributedString, range: getSelectRange())
            setTextViewAttributeString(attributeString:theAttributedString , selectedTextRange: textView.selectedTextRange)
        } else {
            setTextViewAttributeString(attributeString:theAttributedString , selectedTextRange:nil)
        }
        isChangeBoldButton = true
        
        delegate?.scTextViewDidChange?(textView)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard isChangeBoldButton, let button = boldButton else {
            return
        }
        
        attributedText.enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, attributedText.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (value, range, stop) -> Void in
            let font = value as! UIFont
            if range.intersection(getSelectRange()) != nil {
                button.isSelected = font.fontDescriptor.symbolicTraits.contains(.traitBold)
            }
        }
        
        delegate?.scTextViewDidChangeSelection?(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        isChangeBoldButton = false
        return delegate?.scTextView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return delegate?.scTextView?(textView,shouldInteractWith:textAttachment,in:characterRange,interaction:interaction) ?? true
    }
}
