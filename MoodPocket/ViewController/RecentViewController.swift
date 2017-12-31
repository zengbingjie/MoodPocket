//
//  RecentViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/23.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit
import os.log

class RecentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    // MAKR: Properties
    
    @IBOutlet weak var recentCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recentCollection.delegate = self
        recentCollection.dataSource = self
        setupUILayout()
        notificationCenter.addObserver(self, selector: #selector(shouldUpdateLetter), name: NSNotification.Name(rawValue: "lettersUpdated"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(shouldDeleteDiary), name: NSNotification.Name(rawValue: "diaryDeleted"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func shouldUpdateLetter() {
        recentCollection.reloadData()
    }
    
    @objc func shouldDeleteDiary() {
        if let selectedIndexPath = recentCollection?.indexPathsForSelectedItems {
            if !selectedIndexPath.isEmpty{
                // Update an existing diary.
                diaries.remove(at: selectedIndexPath[0].row)
                recentCollection.deleteItems(at: [selectedIndexPath[0]])
                recentCollection.reloadData()
                Diary.saveDiaries()
                let notification = Notification(name: NSNotification.Name(rawValue: "diariesUpdated"), object: self, userInfo: nil)
                notificationCenter.post(notification)
            }
            else {
                recentCollection.reloadData()
            }
        }
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "")
        {
        case "AddDiary":
            os_log("Adding a new diary.", log: OSLog.default, type: .debug)
            
        case "ShowDiaryDetail":
            guard let diaryDetailViewController = segue.destination as? NewMoodViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDiaryCell = sender as? RecentCollectionViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = recentCollection?.indexPath(for: selectedDiaryCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedDiary = diaries[indexPath.row]
            diaryDetailViewController.diary = selectedDiary
            //diaryDetailViewController.diaryIndex = indexPath.row
            //diaryDetailViewController.collectionView = recentCollection
        case "AddLetter": break
        case "EnterPwd": break
        case "ShowMailBox": break
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        switch section {
        case 0:
            if let todayLetter = getTodayLetter() {
                return todayLetter.count>0 ? 2 : 1
            } else {
                return 1
            }
        default:
            return diaries.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row==0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentSummaryCell", for: indexPath) as! RecentSummaryCollectionViewCell
                if diaries.count==0{
                    cell.label.text = "还没有记录, 快添加一个新的心情吧:)"
                } else if getRecentMoodValue()<50 {
                    cell.label.text = "啊哦, 最近心情不太好? 看看以前开心的记录吧:)"
                } else {
                    cell.label.text = "最近心情还不错哦, 继续保持~"
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "receiveLetterCell", for: indexPath)
                return cell
            }
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentCell", for: indexPath) as! RecentCollectionViewCell
            
            // Configure the cell
            let diary = diaries[indexPath.row]
            
            cell.abstractLabel.text = diary.content
            cell.dateLabel.text = diary.date.toString()
            if diary.photo != #imageLiteral(resourceName: "defaultimage") {
                cell.photoImageView.image = diary.photo
                if diary.mood<33 {
                    cell.moodImageView.image = #imageLiteral(resourceName: "colorfulbadmood")
                } else if diary.mood<66 {
                    cell.moodImageView.image = #imageLiteral(resourceName: "nomood")
                } else {
                    cell.moodImageView.image = #imageLiteral(resourceName: "colorfulgoodmood")
                }
            } else {
                if diary.mood<33 {
                    cell.photoImageView.image = #imageLiteral(resourceName: "colorfulbadmood")
                } else if diary.mood<66 {
                    cell.photoImageView.image = #imageLiteral(resourceName: "nomood")
                } else {
                    cell.photoImageView.image = #imageLiteral(resourceName: "colorfulgoodmood")
                }
            }
            return cell
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func unwindToRecentList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? NewMoodViewController {
            sourceViewController.contentTextView.resignFirstResponder()
            if let diary = sourceViewController.diary {
                if let selectedIndexPath = recentCollection?.indexPathsForSelectedItems {
                    if !selectedIndexPath.isEmpty{
                        // Update an existing diary.
                        diaries[selectedIndexPath[0].row] = diary
                        
                    }
                    else {
                        // Add a new diary
                        diaries.insert(diary, at: 0)
                        
                    }
                    // 按时间排序
                    diaries.sort(by: { (d1, d2) -> Bool in
                        return d1.date > d2.date
                    })
                    recentCollection?.reloadData()
                    // 保存数据，通知日历和折线图更新数据
                    Diary.saveDiaries()
                    let notification = Notification(name: NSNotification.Name(rawValue: "diariesUpdated"), object: self, userInfo: nil)
                    notificationCenter.post(notification)
                }
            }
        }
    }
    
    
    // MARK: Private Methods
    
    private func setupUILayout() {
        let itemSize = WIDTH / 2 - 10
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        self.recentCollection!.setCollectionViewLayout(layout, animated: true)
    }
    
    private func getTodayLetter() -> [Letter]? {
        var resultLetters: [Letter] = []
        for letter in letters{
            if letter.receiveDate.toString() == Date().toString(){
                resultLetters.append(letter)
            }
        }
        return resultLetters
    }
    
    private func getRecentMoodValue() -> Int {
        var sumOfMood = 0
        var index = 0
        while index<7 && index<diaries.count{
            sumOfMood += diaries[index].mood
            index += 1
        }
        return Int(sumOfMood/index)
    }

}
