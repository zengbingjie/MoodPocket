//
//  Diary.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/6.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit
import os.log

class Diary: NSObject, NSCoding {
    
    //MARK: Properties
    
    var content: String?
    var photo: UIImage
    var mood: Int
    var date: Date
    var tag: String?
    var isFavourite: Bool
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("diaries")
    
    //MARK: Types
    
    struct PropertyKey {
        static let content = "content"
        static let photo = "photo"
        static let mood = "mood"
        static let date = "date"
        static let tag = "tag"
        static let isFavourite = "isFavourite"
    }
    
    //MARK: Initialization
    
    init(content: String?, photo: UIImage, mood: Int, date: Date, tag: String?, isFavourite: Bool) {
        // Initialize stored properties.
        self.content = content
        self.photo = photo
        self.mood = mood
        self.date = date
        self.tag = tag
        self.isFavourite = isFavourite
    }
    
    // MARK: Static methods
    
    static func loadSampleDiaries() {
        
        let diary1 = Diary(content: "ios太难了", photo: #imageLiteral(resourceName: "defaultimage"), mood: 10, date: Date.stringToDate(string: "2017-12-06"), tag: "Study", isFavourite: false)
        let diary2 = Diary(content: "把tableview改成collectionview啦", photo: #imageLiteral(resourceName: "defaultimage"), mood: 60, date: Date.stringToDate(string: "2017-12-12"), tag: "Study", isFavourite: false)
        let diary3 = Diary(content: "calendar和linechart可以拖动啦！！！！！前前后后改了n遍！！！！", photo: #imageLiteral(resourceName: "defaultimage"), mood: 100, date: Date.stringToDate(string: "2017-12-17"), tag: "Study", isFavourite: false)
        let diary4 = Diary(content: "可以进入app就输入密码啦但是有bug🤯写心情和写信界面退出后重新打开不能显示密码界面🤯", photo: #imageLiteral(resourceName: "defaultimage"), mood: 45, date: Date.stringToDate(string: "2017-12-21"), tag: "Study", isFavourite: false)
        let diary5 = Diary(content: "收藏/添加tag/选择photo功能上线啦", photo: #imageLiteral(resourceName: "defaultimage"), mood: 80, date: Date.stringToDate(string: "2017-12-23"), tag: "Study", isFavourite: false)
        let diary6 = Diary(content: "输入密码bug fixed 感谢wyx同学 一定是我之前的google姿势不对", photo: #imageLiteral(resourceName: "defaultimage"), mood: 90, date: Date.stringToDate(string: "2017-12-25"), tag: "Study", isFavourite: false)
        let diary7 = Diary(content: "Happy Christmas!\n听说英国女王不用merry这个词是因为瞧不上它lol", photo: #imageLiteral(resourceName: "defaultimage"), mood: 60, date: Date.stringToDate(string: "2017-12-25"), tag: "Life", isFavourite: false)
        diaries += [diary1, diary2, diary3, diary4, diary5, diary6, diary7]
        
    }
    
    static func loadDiaries() -> [Diary]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Diary.ArchiveURL.path) as? [Diary]
    }
    
    static func saveDiaries() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(diaries, toFile: Diary.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("diaries successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save diaries...", log: OSLog.default, type: .error)
        }
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content, forKey: PropertyKey.content)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(mood, forKey: PropertyKey.mood)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(tag, forKey: PropertyKey.tag)
        aCoder.encode(isFavourite, forKey: PropertyKey.isFavourite)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let content = aDecoder.decodeObject(forKey: PropertyKey.content) as? String else {
            os_log("Unable to decode the content for a Diary object.", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as! UIImage
        let mood = aDecoder.decodeInteger(forKey: PropertyKey.mood)
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else {
            os_log("Unable to decode the date for a Diary object.", log: OSLog.default, type: .debug)
            return nil
        }
        let tag = aDecoder.decodeObject(forKey: PropertyKey.tag) as? String
        let isFavourite = aDecoder.decodeBool(forKey: PropertyKey.isFavourite)
        self.init(content: content, photo: photo, mood: mood, date: date, tag: tag, isFavourite: isFavourite)
    }
    
    // MARK: Methods
    
    
}
