//
//  SCAlignment.swift
//  SCTextView
//
//  Created by kim sunchul on 2020/05/08.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import UIKit

protocol SCAlignment {
    var leftButton:UIButton? { get set }
    var rightButton:UIButton? { get set }
    var centerButton:UIButton? { get set }
    
    func updateAlignUI(type:NSTextAlignment)
    func updateAlignLeft()
    func updateAlignRight()
    func updateAlignCenter()
}

extension SCAlignment {
    func updateAlignUI(type:NSTextAlignment) {
        switch (type) {
        case .left:
            updateAlignLeft()
            break
        case .center:
            updateAlignCenter()
            break
        case .right:
            updateAlignRight()
            break
        default:
            break
        }
    }
    
    func updateAlignLeft() {
        leftButton?.isSelected = true
        rightButton?.isSelected = false
        centerButton?.isSelected = false
    }
    
    func updateAlignRight() {
        leftButton?.isSelected = false
        rightButton?.isSelected = true
        centerButton?.isSelected = false
    }
    
    func updateAlignCenter() {
        leftButton?.isSelected = false
        rightButton?.isSelected = false
        centerButton?.isSelected = true
    }
}
