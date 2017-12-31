//
//  Letter.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/27.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import Foundation
import os.log

class Letter: NSObject, NSCoding {
    
    // MARK: Properties
    
    var content: String
    var sendDate: Date
    var receiveDate: Date
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("letters")
    
    //MARK: Types
    
    struct PropertyKey {
        static let content = "content"
        static let sendDate = "sendDate"
        static let receiveDate = "receiveDate"
    }
    
    //MARK: Initialization
    
    init(content: String, sendDate: Date, receiveDate: Date) {
        self.content = content
        self.sendDate = sendDate
        self.receiveDate = receiveDate
    }
    
    // MARK: Static methods
    
    static func loadSampleLetters() {
        
        let letter = Letter.init(content: "这是一个sample letter", sendDate: Date(), receiveDate: Date())
        letters.append(letter)
        
    }
    
    static func loadLetters() -> [Letter]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Letter.ArchiveURL.path) as? [Letter]
    }
    
    static func saveLetters() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(letters, toFile: Letter.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("letters successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save letters...", log: OSLog.default, type: .error)
        }
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content, forKey: PropertyKey.content)
        aCoder.encode(sendDate, forKey: PropertyKey.sendDate)
        aCoder.encode(receiveDate, forKey: PropertyKey.receiveDate)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let content = aDecoder.decodeObject(forKey: PropertyKey.content) as! String
        let sendDate = aDecoder.decodeObject(forKey: PropertyKey.sendDate) as! Date
        let receiveDate = aDecoder.decodeObject(forKey: PropertyKey.receiveDate) as! Date
        self.init(content: content, sendDate: sendDate, receiveDate: receiveDate)
    }

}
