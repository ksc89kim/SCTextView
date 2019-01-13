//
//  TestTextView.swift
//  SCTextView
//
//  Created by kim sunchul on 2018. 10. 28..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

class TestTextView: UITextView, NSLayoutManagerDelegate{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutManager.delegate = self
    }

}
