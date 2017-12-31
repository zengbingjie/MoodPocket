//
//  Global.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/19.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import Foundation
import UIKit

let WIDTH = UIScreen.main.bounds.size.width
let HEIGHT = UIScreen.main.bounds.size.height

let COLORS: [UIColor] = [
    UIColor(red: 153/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1), // (0) green
    UIColor(red: 1.0, green: 204/255.0, blue: 153/255.0, alpha: 1), // (1) orange
    UIColor(red: 1.0, green: 204/255.0, blue: 204/255.0, alpha: 1), // (2) pink
    UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1), // (3) grey
    UIColor(red: 242/255.0, green: 158/255.0, blue: 156/255.0, alpha: 1), // (4) bad mood
    UIColor(red: 183/255.0, green: 219/255.0, blue: 146/255.0, alpha: 1), // (5) good mood
    UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1) // (6) grey
]

var config = Config(NEED_PWD: false, PASSWORD: "", PWD_VIEW_MODE: "ENTER", tags: ["Life", "Work", "Study", "Anniversary", "Test"])

var diaries = [Diary]()

var letters = [Letter]()

let notificationCenter = NotificationCenter.default
