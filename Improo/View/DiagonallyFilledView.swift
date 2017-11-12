//
//  DiagonallyFilledView.swift
//  Improo
//
//  Created by Zakhar Garan on 12.11.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit

class DiagonallyFilledView: UIView {
    
    var fillColor: UIColor = UIColor.facebookBlueColor
    
    override func draw(_ rect: CGRect) {
        
        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x: 0, y: 0))
        aPath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        aPath.addLine(to: CGPoint(x: rect.width, y: 0))
        aPath.close()

        fillColor.set()
        aPath.stroke()
        aPath.fill()
    }
}
