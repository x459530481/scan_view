//
//  ScanerView.swift
//  Runner
//
//  Created by tony on 2019/11/13.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import UIKit

class ScanerView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let lineWidth: CGFloat = 3.0 //线的宽度
        let angleLength: CGFloat = 15.0//四角的长度
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(red: 0.0/255, green: 210.0/255, blue: 255.0/255, alpha: 1.0)
        context?.setLineWidth(lineWidth)
        //左上角
        context?.move(to: CGPoint(x: 0, y: 0))
        context?.addLine(to: CGPoint(x: angleLength, y: 0))
        context?.move(to: CGPoint(x: 0, y: 0))
        context?.addLine(to: CGPoint(x: 0, y: angleLength))
        //右上角
        context?.move(to: CGPoint(x: self.frame.width - angleLength, y: 0))
        context?.addLine(to: CGPoint(x: self.frame.width, y: 0))
        context?.addLine(to: CGPoint(x: self.frame.width, y: angleLength))
        //左下角
        context?.move(to: CGPoint(x: 0, y: self.frame.height - angleLength))
        context?.addLine(to: CGPoint(x: 0, y: self.frame.height))
        context?.addLine(to: CGPoint(x: angleLength, y: self.frame.height))
        //右下角
        context?.move(to: CGPoint(x: self.frame.width, y: self.frame.height - angleLength))
        context?.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        context?.addLine(to: CGPoint(x: self.frame.width - angleLength, y: self.frame.height))
        context?.strokePath()
        //
    }
}
