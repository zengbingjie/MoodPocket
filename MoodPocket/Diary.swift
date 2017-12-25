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
    
    var content: String
    var photo: UIImage?
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
    
    static func loadSampleDiaries() {
        
        guard let diary1 = Diary(content: "Just to see what will happen when the content is really really really really really long hhhhhhhhh", photo: nil, mood: 90, date: Date(), tag: "Test", isFavourite: false) else {
            fatalError("Unable to instantiate diary1")
        }
        
        guard let diary2 = Diary(content: "ios太难了", photo: nil, mood: 65, date: Date(), tag: "Study", isFavourite: false) else {
            fatalError("Unable to instantiate diary2")
        }
        
        guard let diary3 = Diary(content: "室友都睡了", photo: nil, mood: 10, date: Date(), tag: "Life", isFavourite: false) else {
            fatalError("Unable to instantiate diary3")
        }
        diaries+=[diary1, diary2, diary3]
        
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
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let mood = aDecoder.decodeInteger(forKey: PropertyKey.mood)
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else {
            os_log("Unable to decode the date for a Diary object.", log: OSLog.default, type: .debug)
            return nil
        }
        let tag = aDecoder.decodeObject(forKey: PropertyKey.tag) as? String
        let isFavourite = aDecoder.decodeBool(forKey: PropertyKey.isFavourite)
        self.init(content: content, photo: photo, mood: mood, date: date, tag: tag, isFavourite: isFavourite)
    }
    
}
