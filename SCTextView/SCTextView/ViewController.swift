//
//  ViewController.swift
//  SCTextView
//
//  Created by kim sunchul on 2018. 9. 29..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

final class ViewController: UIViewController, SCTextViewDelegate{

  // MARK: - UI Components

  @IBOutlet weak var textView: SCTextView!
  @IBOutlet weak var boldButton: UIButton!
  @IBOutlet weak var leftButton: UIButton!
  @IBOutlet weak var centerButton: UIButton!
  @IBOutlet weak var rightButton: UIButton!

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.textView.layer.borderColor = UIColor.black.cgColor
    self.textView.layer.borderWidth = 1

    self.textView.baseFont = UIFont.systemFont(ofSize: 15)
    self.textView.boldFont = UIFont.boldSystemFont(ofSize: 15)
    self.textView.boldButton = self.boldButton
    self.textView.leftButton = self.leftButton
    self.textView.rightButton = self.rightButton
    self.textView.centerButton = self.centerButton
    self.textView.delegate = self
  }
}

