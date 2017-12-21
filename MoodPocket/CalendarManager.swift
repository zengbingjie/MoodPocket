//
//  CalendarManager.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/6.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import Foundation
import UIKit

class CalendarManager{
    
    // MARK: Properties
    
    var selectedDate = Date()
    let weekdayNames = ["日","一","二","三","四","五","六"]
    
    // MARK: Methods
    
    public init (forSelectedDate: Date){
        selectedDate = forSelectedDate
    }
    
    func getSelectedDay() -> Int {
        return selectedDate.getDay()
    }
    
    func getSelectedMonth() -> Int {
        return selectedDate.getMonth()
    }
    
    func getSelectedYear() -> Int {
        return selectedDate.getYear()
    }
    
    func daysInSelectedMonth() -> Int {
        let numOfDays: NSRange = (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: selectedDate)
        return numOfDays.length
    }
    
    // 每个月1号对应的星期
    func firstWeekdayNameInThisMonth() -> Int {
        var cld = Calendar.current
        cld.firstWeekday = 1
        var dateInfo = (cld as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: selectedDate)
        dateInfo.day = 1
        let firstWeekdayName = (cld as NSCalendar).ordinality(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.weekOfMonth, for: cld.date(from: dateInfo)!)
        return firstWeekdayName - 1
    }
    
    // 上个月
    func lastMonth() {
        var dateInterval = DateComponents()
        dateInterval.month = -1
        selectedDate = (Calendar.current as NSCalendar).date(byAdding: dateInterval, to: selectedDate, options: NSCalendar.Options.matchStrictly)!
    }
    
    // 下个月
    func nextMonth() {
        var dateInterval = DateComponents()
        dateInterval.month = 1
        selectedDate = (Calendar.current as NSCalendar).date(byAdding: dateInterval, to: selectedDate, options: NSCalendar.Options.matchStrictly)!
    }
    
    func updateDay(day: Int){
        var dateInterval = DateComponents()
        dateInterval.day = day - getSelectedDay()
        selectedDate = (Calendar.current as NSCalendar).date(byAdding: dateInterval, to: selectedDate, options: NSCalendar.Options.matchStrictly)!
    }
    
    func isToday(forYearMonthPrefix: String, forDay: Int) -> Bool {
        let todayDate = Date().toString()
        let selectedDate = forYearMonthPrefix+"-"+String(format:"%02d",forDay)
        return (todayDate==selectedDate)
    }
    
}

public extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    func getDay() -> Int {
        let dateInfo = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: self)
        return dateInfo.day!
    }
    
    func getMonth() -> Int {
        let dateInfo = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: self)
        return dateInfo.month!
    }
    
    func getYear() -> Int {
        let dateInfo = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: self)
        return dateInfo.year!
    }
    func getWeekdayIndex() -> Int{
        var cld = Calendar.current
        cld.firstWeekday = 1
        let dateInfo = (cld as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: self)
        let firstWeekdayName = (cld as NSCalendar).ordinality(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.weekOfMonth, for: cld.date(from: dateInfo)!)
        return firstWeekdayName - 1
    }
    func minusDays(days: Int) -> Date {
        var dateInterval = DateComponents()
        dateInterval.day = 0-days
        return (Calendar.current as NSCalendar).date(byAdding: dateInterval, to: self, options: NSCalendar.Options.matchStrictly)!
    }
    func plusDays(days: Int) -> Date {
        var dateInterval = DateComponents()
        dateInterval.day = days
        return (Calendar.current as NSCalendar).date(byAdding: dateInterval, to: self, options: NSCalendar.Options.matchStrictly)!
    }
    func minusMonths(months: Int) -> Date {
        var dateInterval = DateComponents()
        dateInterval.month = 0-months
        return (Calendar.current as NSCalendar).date(byAdding: dateInterval, to: self, options: NSCalendar.Options.matchStrictly)!
    }
    func plusMonths(months: Int) -> Date {
        var dateInterval = DateComponents()
        dateInterval.month = months
        return (Calendar.current as NSCalendar).date(byAdding: dateInterval, to: self, options: NSCalendar.Options.matchStrictly)!
    }
}
