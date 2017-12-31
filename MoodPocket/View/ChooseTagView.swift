//
//  ChooseTagView.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/25.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit

class ChooseTagView: UIView {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            let myFrame = self.bounds
            context.setLineWidth(1.0)
            myFrame.insetBy(dx: 50, dy: 50)
            UIColor.lightGray.set()
            UIRectFrame(myFrame)
        }
    }
}
