//
//  ViewController.swift
//  SCTextView
//
//  Created by kim sunchul on 2018. 9. 29..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
    @IBAction func clickBold(_ sender: Any) {
        let theAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let boldFont = UIFont.boldSystemFont(ofSize:14)
        let baseFont = UIFont.systemFont(ofSize: 14)

        let selectedRange = textView.selectedRange
        let selectedTextRange = textView.selectedTextRange

        theAttributedString.beginEditing()
        var isFound = false
        var isBold = false
        theAttributedString.enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, theAttributedString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (value, range, stop) -> Void in
            if range.intersection(selectedRange) != nil {
                isFound = true
                if let oldFont = value as? UIFont  {
                    isBold = oldFont.fontDescriptor.symbolicTraits.contains(.traitBold)
                }
            }
        }

        if isFound {
            if isBold {
                theAttributedString.addAttribute(NSAttributedString.Key.font, value: baseFont, range: selectedRange)
            } else {
                theAttributedString.addAttribute(NSAttributedString.Key.font, value: boldFont, range: selectedRange)
            }
        } else {
            theAttributedString.addAttribute(NSAttributedString.Key.font, value: boldFont, range: selectedRange)
        }
        
        theAttributedString.endEditing()
        
        textView.attributedText = theAttributedString
        textView.selectedTextRange = selectedTextRange
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
}

