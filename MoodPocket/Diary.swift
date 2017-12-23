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
    var photo: UIImage?
    var mood: Int
    var date: Date
    var tag: String?
    var isFavourite: Bool
    
    //MARK: Initialization
    
    init?(content: String, photo: UIImage?, mood: Int, date: Date, tag: String?, isFavourite: Bool) {
        // Initialize stored properties.
        if content.isEmpty || (mood<0||mood>100) {
            return nil
        }
        self.content = content
        if let newphoto = photo {
            self.photo = newphoto
        } else {
            self.photo = UIImage(named: "defaultimage")
        }
        self.mood = mood
        self.date = date
        self.tag = tag
        self.isFavourite = isFavourite
    }
}
