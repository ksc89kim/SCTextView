//
//  ViewController.swift
//  SCTextView
//
//  Created by kim sunchul on 2018. 9. 29..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SCTextViewDelegate{
    @IBOutlet weak var textView: SCTextView!
    @IBOutlet weak var boldButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        
        textView.baseFont = UIFont.systemFont(ofSize: 15)
        textView.boldFont = UIFont.boldSystemFont(ofSize: 15)
        textView.boldButton = boldButton
        textView.leftButton = leftButton
        textView.rightButton = rightButton
        textView.centerButton = centerButton
        textView.delegate = self
    }
}

