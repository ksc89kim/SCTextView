//
//  UIButtonExtensions.swift
//  SCTextView
//
//  Created by kim sunchul on 2020/05/08.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import UIKit

extension UIButton {
    func toggle() {
        self.isSelected = self.isSelected ? false : true
    }
}
