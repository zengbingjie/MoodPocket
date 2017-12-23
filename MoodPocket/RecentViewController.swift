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
class RecentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MAKR: Properties
    
    var diaries = [Diary]()
    @IBOutlet weak var recentCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recentCollection.delegate = self
        recentCollection.dataSource = self
        setupUILayout()
        loadSampleDiaries()
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
        case "AddLetter": break
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: UICollectionViewDataSource
    
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
                        recentCollection?.reloadItems(at: selectedIndexPath)
                    }
                    else {
                        // Add a new diary
                        diaries.insert(diary, at: 0)
                        recentCollection?.insertItems(at: [IndexPath(row: 0, section: 0)])
                    }
                }
            }
        }
    }
    
    
    // MARK: Private Methods
    
    private func loadSampleDiaries() {
        
        guard let diary1 = Diary(content: "Just to see what will happen when the content is really really really really really long hhhhhhhhh", photo: nil, mood: 90, date: Date(), tag: "test", isFavourite: false) else {
            fatalError("Unable to instantiate diary1")
        }
        
        guard let diary2 = Diary(content: "ios太难了", photo: nil, mood: 65, date: Date(), tag: "study", isFavourite: false) else {
            fatalError("Unable to instantiate diary2")
        }
        
        guard let diary3 = Diary(content: "室友都睡了", photo: nil, mood: 10, date: Date(), tag: "life", isFavourite: false) else {
            fatalError("Unable to instantiate diary3")
        }
        diaries+=[diary1, diary2, diary3]
        
    }
    
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
