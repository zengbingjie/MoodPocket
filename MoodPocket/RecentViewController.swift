//
//  RecentViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/23.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit
import os.log

private let reuseIdentifier = "recentCell"
class RecentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    // MAKR: Properties
    
    @IBOutlet weak var recentCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recentCollection.delegate = self
        recentCollection.dataSource = self
        setupUILayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            diaryDetailViewController.diaryIndex = indexPath.row
            diaryDetailViewController.collectionView = recentCollection
        case "AddLetter": break
        case "EnterPwd": break
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return diaries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecentCollectionViewCell
        
        // Configure the cell
        let diary = diaries[indexPath.row]
        
        cell.abstractLabel.text = diary.content
        cell.dateLabel.text = diary.date.toString()
        if diary.photo != UIImage(named: "defaultimage"){
            cell.photoImageView.image = diary.photo
            if diary.mood<33 {
                cell.moodImageView.image = UIImage(named: "colorfulbadmood")
            } else if diary.mood<66 {
                cell.moodImageView.image = UIImage(named: "nomood")
            } else {
                cell.moodImageView.image = UIImage(named: "colorfulgoodmood")
            }
        } else {
            if diary.mood<33 {
                cell.photoImageView.image = UIImage(named: "colorfulbadmood")
            } else if diary.mood<66 {
                cell.photoImageView.image = UIImage(named: "nomood")
            } else {
                cell.photoImageView.image = UIImage(named: "colorfulgoodmood")
            }
        }
        return cell
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
                    Diary.saveDiaries()
                    let notification = Notification(name: NSNotification.Name(rawValue: "diariesUpdated"), object: self, userInfo: nil)
                    notificationCenter.post(notification)
                }
            }
        }
    }
    
    
    // MARK: Private Methods
    
    private func setupUILayout() {
        let itemSize = WIDTH / 2 - 18
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        self.recentCollection!.setCollectionViewLayout(layout, animated: true)
    }

}
