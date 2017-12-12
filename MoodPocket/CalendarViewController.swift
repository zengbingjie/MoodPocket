//
//  CalendarViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/6.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit
import os.log

let HEIGHT = UIScreen.main.bounds.size.height
let WIDTH = UIScreen.main.bounds.size.width

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource{
    
    // MARK: Properties
    @IBOutlet weak var calendarCollection: UICollectionView!
    @IBOutlet weak var lastMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBOutlet weak var calendarTable: UITableView!
    
    let calendar = CalendarManager()
    
    var currentSelectedCellIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentSelectedCellIndex = getDefaultSelectedCellIndex()
        setupUILayout()
        calendarCollection.delegate = self
        calendarCollection.dataSource = self
        calendarTable.delegate = self
        calendarTable.dataSource = self
        self.calendarCollection.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "dateCell")
        self.calendarCollection.register(WeekdayNameCollectionViewCell.self, forCellWithReuseIdentifier: "weekCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return calendar.weekdayNames.count
        default:
            return calendar.daysInSelectedMonth() + calendar.firstWeekdayNameInThisMonth()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (indexPath as NSIndexPath).section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekCell", for: indexPath) as! WeekdayNameCollectionViewCell
            cell.timeLabel.text = calendar.weekdayNames[(indexPath as NSIndexPath).row] as String
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCollectionViewCell
            let firstWeekdayName = calendar.firstWeekdayNameInThisMonth()
            let index = indexPath.row
            if index < calendar.firstWeekdayNameInThisMonth() {
                cell.timeLabel.text = nil
                cell.backgroundColor = UIColor.white
            } else {
                let day = index + 1 - firstWeekdayName
                cell.timeLabel.text = String(day)
                if calendar.isToday(forYearMonthPrefix: currentMonthLabel.text!, forDay: day) {
                    cell.backgroundColor = UIColor(red: 0.95, green: 0.676, blue: 0.875, alpha: 1.0)
                } else if index==currentSelectedCellIndex {
                    cell.backgroundColor = UIColor.lightGray
                } else {
                    cell.backgroundColor = UIColor.white
                }
            }
            return cell
        default:
            fatalError("Unexpected Collection Section; \(String(describing: indexPath.section))")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row) != currentSelectedCellIndex {
            let cell = collectionView.cellForItem(at: indexPath)
            if cell is DateCollectionViewCell {
                if let text = (cell as! DateCollectionViewCell).timeLabel.text {
                    calendar.updateDay(day: Int(text)!)
                    if !calendar.isToday(forYearMonthPrefix: currentMonthLabel.text!, forDay: Int((cell as! DateCollectionViewCell).timeLabel.text!)!){
                        cell?.backgroundColor = UIColor.lightGray
                    }
                    //上一个选中的背景变白色，取消选择
                    guard let lastSelectedCell = collectionView.cellForItem(at: NSIndexPath(row: currentSelectedCellIndex, section: 1) as IndexPath) else {
                        os_log("not a date cell", log: OSLog.default, type: .debug)
                        return
                    }
                    if !calendar.isToday(forYearMonthPrefix: currentMonthLabel.text!, forDay: Int((lastSelectedCell as! DateCollectionViewCell).timeLabel.text!)!){
                        lastSelectedCell.backgroundColor = UIColor.white
                    }
                    collectionView.deselectItem(at: NSIndexPath(row: currentSelectedCellIndex, section: 1) as IndexPath, animated: true)
                    // set new currentSelectedCellIndex
                    currentSelectedCellIndex = indexPath.row
                }
            }
        }
    }
    
    // MARK: Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell", for: indexPath) as? RecentTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RecentTableViewCell.")
        }
        // Configure the cell...
        // TODO: Update the cell according to the selected date
        cell.abstractLabel.text = "aaaaaa"
        cell.dateLabel.text = Date().toString()
        cell.moodImageView.image = UIImage(named: "goodmood")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: Actions
    @IBAction func lastMonthButtonTapped(_ sender: UIButton) {
        UIView.transition(with: self.calendarCollection, duration: 0.3, options: .transitionCrossDissolve, animations: {
            let dayInThisMonth = self.calendar.getSelectedDay()
            self.calendar.lastMonth()
            self.currentSelectedCellIndex = self.calendar.firstWeekdayNameInThisMonth() + dayInThisMonth - 1
            self.currentMonthLabel.text = String(format: "%li-%.2ld", self.calendar.getSelectedYear(), self.calendar.getSelectedMonth())
        }, completion: nil)
        self.calendarCollection.reloadData()
    }

    @IBAction func nextMonthButtonTapped(_ sender: UIButton) {
        UIView.transition(with: self.calendarCollection, duration: 0.3, options: .transitionCrossDissolve, animations: {
            let dayInThisMonth = self.calendar.getSelectedDay()
            self.calendar.nextMonth()
            self.currentSelectedCellIndex = self.calendar.firstWeekdayNameInThisMonth() + dayInThisMonth - 1
            self.currentMonthLabel.text = String(format: "%li-%.2ld", self.calendar.getSelectedYear(), self.calendar.getSelectedMonth())
        }, completion: nil)
        self.calendarCollection.reloadData()
    }
    
    // MARK: Private Methods
    
    private func getDefaultSelectedCellIndex() -> Int{
        return calendar.getSelectedDay()+calendar.firstWeekdayNameInThisMonth()-1
    }
    
    func setupUILayout() {
        // lastMonthButton
        lastMonthButton.frame = CGRect(x: 10, y: 64, width: 30, height: 40)
        lastMonthButton.setTitle("<", for: UIControlState())
        lastMonthButton.setTitleColor(UIColor.black, for: UIControlState())
        
        // nextMonthButton
        nextMonthButton.frame = CGRect(x: WIDTH - 40, y: 64, width: 30, height: 40)
        nextMonthButton.setTitle(">", for: UIControlState())
        nextMonthButton.setTitleColor(UIColor.black, for: UIControlState())
        
        // currentMonthLabel
        currentMonthLabel.frame = CGRect(x: lastMonthButton.frame.maxX, y: lastMonthButton.frame.minY, width: WIDTH - lastMonthButton.frame.width - nextMonthButton.frame.width - 10, height: 40)
        
        // collection view
        let itemSize = WIDTH / 7 - 5
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: itemSize, height: 40)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let rect = CGRect(x: 10, y: lastMonthButton.frame.maxY, width: WIDTH, height: 300)
        calendarCollection.setCollectionViewLayout(layout, animated: true)
        calendarCollection.frame = rect
        calendarCollection.backgroundColor = UIColor.white
        
        // currentMonthLabel
        self.currentMonthLabel.text = String(format: "%li-%.2ld", calendar.getSelectedYear(), calendar.getSelectedMonth())
        
        // table view
        calendarTable.frame = CGRect(x:0, y:calendarCollection.frame.maxY, width:WIDTH, height: HEIGHT - calendarCollection.frame.maxY)
        calendarTable.isScrollEnabled = true
    }

}
