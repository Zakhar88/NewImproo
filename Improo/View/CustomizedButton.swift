//
//  CustomizedButton.swift
//  Improo
//
//  Created by Zakhar Garan on 12/13/17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

class CustomizedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }
    
    private func customize() {
        layer.cornerRadius = 5
        backgroundColor = UIColor.mainThemeColor
        setTitleColor(UIColor.white, for: .normal)
    }
}
