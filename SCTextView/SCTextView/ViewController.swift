//
//  ViewController.swift
//  SCTextView
//
//  Created by kim sunchul on 2018. 9. 29..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textView: TestTextView!
    
    var attributedText: NSAttributedString!
    @IBOutlet weak var boldButton: UIButton!
    var isChangeBoldButton:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attributedText = textView.attributedText
        self.textView.delegate = self
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
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
            addAttributeString(isBold: boldButton.isSelected, attributeString: theAttributedString, range: getSelectRange())
            setTextViewAttributeString(attributeString:theAttributedString , selectedTextRange: textView.selectedTextRange)
        } else {
            setTextViewAttributeString(attributeString:theAttributedString , selectedTextRange:nil)
        }
        isChangeBoldButton = true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard isChangeBoldButton else {
            return
        }
        
        attributedText.enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, attributedText.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (value, range, stop) -> Void in
            let font = value as! UIFont
            if range.intersection(getSelectRange()) != nil {
                boldButton.isSelected = font.fontDescriptor.symbolicTraits.contains(.traitBold)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        isChangeBoldButton = false
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
    @IBAction func clickBold(_ sender: Any) {
        let button:UIButton = sender as! UIButton
        if button.isSelected {
            button.isSelected = false
        } else {
            button.isSelected = true
        }
        
        let theAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        addAttributeString(isBold: button.isSelected, attributeString: theAttributedString, range: textView.selectedRange)
        setTextViewAttributeString(attributeString:theAttributedString , selectedTextRange: textView.selectedTextRange)
    }
    
    @IBAction func clickLeft(_ sender: Any) {
        textView.textAlignment = .left
    }
    
    @IBAction func clickCenter(_ sender: Any) {
        textView.textAlignment = .center
    }
    
    @IBAction func clickRight(_ sender: Any) {
        textView.textAlignment = .right
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
        let boldFont = UIFont.boldSystemFont(ofSize:14)
        let baseFont = UIFont.systemFont(ofSize: 14)
        if isBold {
            attributeString.addAttribute(NSAttributedString.Key.font, value: boldFont, range: range)
        } else {
            attributeString.addAttribute(NSAttributedString.Key.font, value: baseFont, range: range)
        }
    }
}

