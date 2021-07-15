//
//  UIViewExtensions.swift
//  SCTextView
//
//  Created by kim sunchul on 2020/05/08.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import UIKit

extension UIView {
  func setBaseConstraint(view:UIView) {
    self.translatesAutoresizingMaskIntoConstraints = false
    view.widthAnchor.constraint(equalTo:self.widthAnchor, constant: 0 ).isActive = true
    view.heightAnchor.constraint(equalTo:self.heightAnchor, constant: 0 ).isActive = true
    view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
    view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
  }
}
