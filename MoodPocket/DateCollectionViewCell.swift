//
//  DateCollectionViewCell.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/6.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    lazy var timeLabel: UILabel = {
        let time = UILabel(frame: CGRect.zero)
        time.textAlignment = .center
        self.addSubview(time)
        return time
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        timeLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.size.width/7-5, height: 20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
