//
//  Config.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/25.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import Foundation

import UIKit
import os.log

class Config: NSObject, NSCoding {
    
    //MARK: Properties
    
    var NEED_PWD = false
    var PASSWORD = ""
    var PWD_VIEW_MODE = "ENTER"
    var tags: [String] = ["Life", "Work", "Study", "Anniversary", "Test"]
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("config")
    
    //MARK: Types
    
    struct PropertyKey {
        static let NEED_PWD = "NEED_PWD"
        static let PASSWORD = "PASSWORD"
        static let PWD_VIEW_MODE = "PWD_VIEW_MODE"
        static let tags = "tags"
    }
    
    //MARK: Initialization
    
    init(NEED_PWD: Bool, PASSWORD: String, PWD_VIEW_MODE: String, tags: [String]) {
        // Initialize stored properties.
        self.NEED_PWD = NEED_PWD
        self.PASSWORD = PASSWORD
        self.PWD_VIEW_MODE = PWD_VIEW_MODE
        self.tags = tags
    }
    
    static func loadConfig() -> Config? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Config.ArchiveURL.path) as? Config
    }
    
    static func loadDefaultConfig() {
        config.NEED_PWD = false
        config.PASSWORD = ""
        config.PWD_VIEW_MODE = "ENTER"
        config.tags = ["Life", "Work", "Study", "Anniversary", "Test"]
    }
    
    static func saveConfig() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(config, toFile: Config.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("config successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save config...", log: OSLog.default, type: .error)
        }
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(NEED_PWD, forKey: PropertyKey.NEED_PWD)
        aCoder.encode(PASSWORD, forKey: PropertyKey.PASSWORD)
        aCoder.encode(PWD_VIEW_MODE, forKey: PropertyKey.PWD_VIEW_MODE)
        aCoder.encode(tags, forKey: PropertyKey.tags)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let NEED_PWD = aDecoder.decodeBool(forKey: PropertyKey.NEED_PWD)
        let PASSWORD = aDecoder.decodeObject(forKey: PropertyKey.PASSWORD) as! String
        let PWD_VIEW_MODE = aDecoder.decodeObject(forKey: PropertyKey.PWD_VIEW_MODE)  as! String
        let tags = aDecoder.decodeObject(forKey: PropertyKey.tags) as! [String]
        self.init(NEED_PWD: NEED_PWD, PASSWORD: PASSWORD, PWD_VIEW_MODE: PWD_VIEW_MODE, tags: tags)
    }
    
}

