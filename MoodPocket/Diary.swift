//
//  Diary.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/6.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit

class Diary {
    
    //MARK: Properties
    
    var content: String
    var photos: [UIImage]?
    var mood: Int
    var date: Date
    var tag: String?
    
    //MARK: Initialization
    
    init?(content: String, photos: [UIImage]?, mood: Int, date: Date, tag: String?) {
        // Initialize stored properties.
        if content.isEmpty || (mood<0||mood>100) {
            return nil
        }
        self.content = content
        self.photos = photos
        self.mood = mood
        self.date = date
        self.tag = tag
    }
}