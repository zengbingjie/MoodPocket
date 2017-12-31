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
        
        let letter = Letter.init(content: "This is a sample letter.\n给十年后的我\n歌手：薛凯琪\n作词：黄伟文\n这十年来做过的事能令你无悔骄傲吗\n那时候你所相信的事\n没有被动摇吧\n对象和缘份已出现\n成就也还算不赖吗\n旅途上你增添了经历\n又有让棱角消失吗\n软弱吗\n你成熟了不会失去格调吧\n当初坚持还在吗\n刀锋不会磨钝了吧\n老练吗\n你情愿变得聪明而不冲动吗\n但变成步步停下三思会累吗\n快乐吗\n你还是记得你跟我约定吧\n区区几场成败里\n应该不致麻木了吧\n你忘掉理想只能忙于生活吗\n别太迟又十年后至想快乐吗", sendDate: Date(), receiveDate: Date())
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
