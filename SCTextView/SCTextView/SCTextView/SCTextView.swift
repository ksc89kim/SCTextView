//
//  SCTextView.swift
//  SCTextView
//
//  Created by kim sunchul on 2019. 1. 26..
//  Copyright © 2019년 kim sunchul. All rights reserved.
//

import UIKit

@objc protocol SCTextViewDelegate:class {
    @objc optional func scTextViewShouldBeginEditing(_ textView: UITextView) -> Bool
    @objc optional func scTextViewShouldEndEditing(_ textView: UITextView) -> Bool
    @objc optional func scTextViewDidChange(_ textView: UITextView)
    @objc optional func scTextViewDidChangeSelection(_ textView: UITextView)
    @objc optional func scTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    @objc optional func scTextView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
}

final class SCTextView: UIView, SCAlignment, SCBold{    
    @IBOutlet var view: UIView!
    @IBOutlet weak var textView: UITextView!
    weak var delegate:SCTextViewDelegate?

    // SCBold
    var boldFont:UIFont?
    var baseFont:UIFont?
    var tempAttributedString: NSAttributedString = NSAttributedString(string: "")
    var isChangeBoldUI:Bool = false
    weak var boldButton:UIButton? {
        didSet{
            boldButton?.addTarget(self, action: #selector(onBold(sender:)), for: .touchUpInside)
        }
    }
    
    // SCAlignment
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
        self.addSubview(view);
        self.setBaseConstraint(view: self.view)
    }
    
    func setEvent() {
        textView.delegate = self
    }
    
    @objc func onBold(sender:UIButton) {
        sender.toggle()
        let editAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        addAttributeStringForBoldStatus(attributeString: editAttributedString, range: textView.selectedRange)
        setTextViewAttributeString(attributeString:editAttributedString , selectedTextRange: textView.selectedTextRange)
    }
    
    @objc func onLeft(sender:UIButton) {
        textView.textAlignment = .left
        updateAlignUI(type:textView.textAlignment)
    }
    
    @objc func onRight(sender:UIButton) {
        textView.textAlignment = .right
        updateAlignUI(type:textView.textAlignment)
    }
    
    @objc func onCenter(sender:UIButton) {
        textView.textAlignment = .center
        updateAlignUI(type:textView.textAlignment)
    }
    
    func setTextViewAttributeString(attributeString:NSMutableAttributedString, selectedTextRange:UITextRange?){
        textView.attributedText = attributeString
        tempAttributedString = textView.attributedText
        if selectedTextRange != nil {
            textView.selectedTextRange = selectedTextRange
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
        guard boldButton != nil else {
            return
        }
    
        if let editAttributedString = getEditAttributedString(textView: textView) {
            setTextViewAttributeString(attributeString:editAttributedString , selectedTextRange:textView.selectedTextRange)
        } else {
            setTextViewAttributeString(attributeString:NSMutableAttributedString(attributedString: textView.attributedText) , selectedTextRange:nil)
        }

        isChangeBoldUI = true
        delegate?.scTextViewDidChange?(textView)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        updateBoldUI(textView: textView)
        delegate?.scTextViewDidChangeSelection?(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        isChangeBoldUI = false
        return delegate?.scTextView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return delegate?.scTextView?(textView,shouldInteractWith:textAttachment,in:characterRange,interaction:interaction) ?? true
    }
}
