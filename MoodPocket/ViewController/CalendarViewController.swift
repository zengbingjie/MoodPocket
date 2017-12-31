//
//  CalendarViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/6.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit
import os.log

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource{
    
    // MARK: Properties
    @IBOutlet weak var lastCalendarCollection: UICollectionView!
    @IBOutlet weak var nextCalendarCollection: UICollectionView!
    @IBOutlet weak var calendarCollection: UICollectionView!
    
    @IBOutlet weak var lastMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var currentMonthLabel: UILabel!
    
    @IBOutlet weak var calendarTable: UITableView!
    
    let calendar = CalendarManager(forSelectedDate: Date())
    let lastCalendar = CalendarManager(forSelectedDate: Date().minusMonths(months: 1))
    let nextCalendar = CalendarManager(forSelectedDate: Date().plusMonths(months: 1))
    
    var currentSelectedCellIndex: Int = 0
    
    var selectedDiaries = [Diary]()
    
    fileprivate var panGestureStartLocation: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentSelectedCellIndex = getDefaultSelectedCellIndex()
        setupUILayout()
        initializingWork()
        refreshCalendarTable()
        notificationCenter.addObserver(self, selector: #selector(shouldRefreshCalendarTable), name: NSNotification.Name(rawValue: "diariesUpdated"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(shouldDeleteDiary), name: NSNotification.Name(rawValue: "diaryDeleted"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func shouldDeleteDiary() {
        if let selectedIndexPath = calendarTable.indexPathForSelectedRow {
            // Delete an existing diary.
            let deleteDiary = selectedDiaries[selectedIndexPath.row]
            for index in 0..<diaries.count {
                if deleteDiary==diaries[index]{
                    diaries.remove(at: index)
                    break
                }
            }
            selectedDiaries.remove(at: selectedIndexPath.row)
            calendarTable.deleteRows(at: [selectedIndexPath], with: .fade)
            calendarTable.reloadData()
            Diary.saveDiaries()
        }
    }
    
    @objc func shouldRefreshCalendarTable() {
        refreshCalendarTable()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        guard let diaryDetailViewController = segue.destination as? CheckDiaryViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        guard let selectedDiaryCell = sender as? RecentTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        guard let indexPath = calendarTable?.indexPath(for: selectedDiaryCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        let selectedDiary = diaries[indexPath.row]
        diaryDetailViewController.diary = selectedDiary
        diaryDetailViewController.navigationTitle.title = selectedDiary.date.toString()
    }
    
    
    // Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        default:
            return 42
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cld = getCorrespondingCalendar(forCollectionView: collectionView)
        switch (indexPath as NSIndexPath).section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekCell", for: indexPath) as! WeekdayNameCollectionViewCell
            cell.timeLabel.text = calendar.weekdayNames[(indexPath as NSIndexPath).row] as String
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCollectionViewCell
            let firstWeekdayName = cld.firstWeekdayNameInThisMonth()
            let index = indexPath.row
            if index < cld.firstWeekdayNameInThisMonth() || index > cld.daysInSelectedMonth()+cld.firstWeekdayNameInThisMonth()-1{
                cell.timeLabel.text = nil
                cell.backgroundColor = UIColor.white
            } else {
                let day = index + 1 - firstWeekdayName
                cell.timeLabel.text = String(day)
                if cld.isToday(forYearMonthPrefix: currentMonthLabel.text!, forDay: day) && collectionView===calendarCollection {
                    cell.backgroundColor = COLORS[1]
                } else if index==currentSelectedCellIndex {
                    cell.backgroundColor = COLORS[3]
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
                        cell?.backgroundColor = COLORS[3]
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
                    refreshCalendarTable()
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
        if selectedDiaries.count>0 {
            return selectedDiaries.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedDiaries.count>0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell", for: indexPath) as? RecentTableViewCell  else {
                fatalError("The dequeued cell is not an instance of RecentTableViewCell.")
            }
            // Configure the cell...
            let diary = selectedDiaries[indexPath.row]
            cell.abstractLabel.text = diary.content
            cell.dateLabel.text = diary.date.toString()
            // 没有photo 显示大表情
            if selectedDiaries[indexPath.row].photo == #imageLiteral(resourceName: "defaultimage"){
                if diary.mood<33 {
                    cell.photoImageView.image = #imageLiteral(resourceName: "colorfulbadmood")
                } else if diary.mood<66 {
                    cell.photoImageView.image = #imageLiteral(resourceName: "nomood")
                } else {
                    cell.photoImageView.image = #imageLiteral(resourceName: "colorfulgoodmood")
                }
                cell.moodImageView.image = nil
            } else {
                cell.photoImageView.image = diary.photo
                if diary.mood<33 {
                    cell.moodImageView.image = #imageLiteral(resourceName: "colorfulbadmood")
                } else if diary.mood<66 {
                    cell.moodImageView.image = #imageLiteral(resourceName: "nomood")
                } else {
                    cell.moodImageView.image = #imageLiteral(resourceName: "colorfulgoodmood")
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NothingCell", for: indexPath)
            return cell
        }
    }
    
    /*
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
    */
    // MARK: Actions
    @IBAction func lastMonthButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.calendarCollection.center.x = WIDTH * 1.5
            self.lastCalendarCollection.center.x = WIDTH * 0.5
        }, completion: self.lastViewDidShow)
    }
    
    fileprivate func lastViewDidShow(_ finished: Bool) {
        if finished {
            gotoLastMonth()
            resetUILayout()
            currentMonthLabel.text = String(format: "%li-%.2ld", calendar.getSelectedYear(), calendar.getSelectedMonth())
            refreshCalendarTable()
        }
    }

    @IBAction func nextMonthButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.calendarCollection.center.x = -WIDTH * 0.5
            self.nextCalendarCollection.center.x = WIDTH * 0.5
        }, completion: self.nextViewDidShow)
    }
    
    fileprivate func nextViewDidShow(_ finished: Bool) {
        if finished {
            gotoNextMonth()
            resetUILayout()
            currentMonthLabel.text = String(format: "%li-%.2ld", calendar.getSelectedYear(), calendar.getSelectedMonth())
            refreshCalendarTable()
        }
    }
    
    @IBAction func dragCalendar(_ sender: UIPanGestureRecognizer) {
        if sender.location(in: calendarCollection).y<=calendarCollection.bounds.maxY{
            switch sender.state {
                
            case .began:
                self.panGestureStartLocation = sender.location(in: calendarCollection).x
                
            case .changed:
                let changeInX = sender.location(in: calendarCollection).x - self.panGestureStartLocation
                
                lastCalendarCollection.center.x += changeInX
                calendarCollection.center.x += changeInX
                nextCalendarCollection.center.x += changeInX
                
                self.panGestureStartLocation = sender.location(in: calendarCollection).x
                
            case .ended:
                if self.calendarCollection.center.x < (WIDTH * 0.5) - 50 {
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.calendarCollection.center.x = -WIDTH * 0.5
                        self.nextCalendarCollection.center.x = WIDTH * 0.5
                    }, completion: self.nextViewDidShow)
                }
                else if self.calendarCollection.center.x > (WIDTH * 0.5) + 50 {
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.calendarCollection.center.x = WIDTH * 1.5
                        self.lastCalendarCollection.center.x = WIDTH * 0.5
                    }, completion: self.lastViewDidShow)
                }
                else {
                    
                    UIView.animate(withDuration: 0.15, animations: {
                        self.resetUILayout()
                    })
                }
                
            default:
                break
            }
        }
    }
    
    // MARK: Private Methods
    
    private func gotoLastMonth() {
        let date = calendar.getSelectedDay()
        calendar.lastMonth()
        lastCalendar.lastMonth()
        nextCalendar.lastMonth()
        currentSelectedCellIndex = calendar.firstWeekdayNameInThisMonth() + date - 1
        calendarCollection.reloadData()
        lastCalendarCollection.reloadData()
        nextCalendarCollection.reloadData()
    }
    
    private func gotoNextMonth(){
        let date = calendar.getSelectedDay()
        calendar.nextMonth()
        lastCalendar.nextMonth()
        nextCalendar.nextMonth()
        currentSelectedCellIndex = calendar.firstWeekdayNameInThisMonth() + date - 1
        calendarCollection.reloadData()
        lastCalendarCollection.reloadData()
        nextCalendarCollection.reloadData()
    }
    
    private func getDefaultSelectedCellIndex() -> Int{
        return calendar.getSelectedDay()+calendar.firstWeekdayNameInThisMonth()-1
    }
    
    private func resetUILayout() {
        lastCalendarCollection.center.x = -WIDTH * 0.5
        calendarCollection.center.x = WIDTH * 0.5
        nextCalendarCollection.center.x = WIDTH * 1.5
    }
    
    private func setupUILayout() {
        // 3 collection views
        let itemSize = UIScreen.main.bounds.size.width / 7 - 5
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: itemSize, height: 40)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        calendarCollection.setCollectionViewLayout(layout, animated: true)
        calendarCollection.backgroundColor = UIColor.white
        lastCalendarCollection.setCollectionViewLayout(layout, animated: true)
        lastCalendarCollection.backgroundColor = UIColor.white
        nextCalendarCollection.setCollectionViewLayout(layout, animated: true)
        nextCalendarCollection.backgroundColor = UIColor.white
        
        // currentMonthLabel
        self.currentMonthLabel.text = String(format: "%li-%.2ld", calendar.getSelectedYear(), calendar.getSelectedMonth())
        
        // table view
        calendarTable.isScrollEnabled = true
    }
    
    private func initializingWork() {
        
        calendarTable.delegate = self
        calendarTable.dataSource = self
        
        calendarCollection.delegate = self
        calendarCollection.dataSource = self
        calendarCollection.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "dateCell")
        calendarCollection.register(WeekdayNameCollectionViewCell.self, forCellWithReuseIdentifier: "weekCell")
        
        lastCalendarCollection.delegate = self
        lastCalendarCollection.dataSource = self
        lastCalendarCollection.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "dateCell")
        lastCalendarCollection.register(WeekdayNameCollectionViewCell.self, forCellWithReuseIdentifier: "weekCell")
        
        nextCalendarCollection.delegate = self
        nextCalendarCollection.dataSource = self
        nextCalendarCollection.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "dateCell")
        nextCalendarCollection.register(WeekdayNameCollectionViewCell.self, forCellWithReuseIdentifier: "weekCell")
        
    }
    
    private func getCorrespondingCalendar(forCollectionView: UICollectionView)->CalendarManager{
        if forCollectionView===lastCalendarCollection{
            return lastCalendar
        }
        else if forCollectionView===calendarCollection{
            return calendar
        } else {
            return nextCalendar
        }
    }
    
    private func getDiariesOfSelectedDate() -> [Diary]? {
        var resultDiaries = [Diary]()
        for d in diaries {
            if (d.date.toString() == calendar.selectedDate.toString()){
                resultDiaries += [d]
            }
        }
        return resultDiaries
    }
    
    private func refreshCalendarTable() {
        selectedDiaries = getDiariesOfSelectedDate()!
        calendarTable.reloadData()
    }
    
    
}
