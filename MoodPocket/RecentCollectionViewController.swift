//
//  RecentCollectionViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/12.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit
import os.log

private let reuseIdentifier = "recentCell"

class RecentCollectionViewController: UICollectionViewController {

    var diaries = [Diary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
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
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDiaryDetail":
            guard let diaryDetailViewController = segue.destination as? NewMoodViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDiaryCell = sender as? RecentCollectionViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = collectionView?.indexPath(for: selectedDiaryCell) else {
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return diaries.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecentCollectionViewCell
    
        // Configure the cell
        let diary = diaries[indexPath.row]
        
        cell.abstractLabel.text = diary.content
        cell.dateLabel.text = diary.date.toString()
        if diary.mood<33 {
            cell.moodImageView.image = UIImage(named: "badmood")
        } else if diary.mood<66 {
            cell.moodImageView.image = UIImage(named: "nomood")
        } else {
            cell.moodImageView.image = UIImage(named: "goodmood")
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: Actions
    
    @IBAction func unwindToRecentList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? NewMoodViewController {
            sourceViewController.contentTextView.resignFirstResponder()
            if let diary = sourceViewController.diary {
                if let selectedIndexPath = collectionView?.indexPathsForSelectedItems {
                    if !selectedIndexPath.isEmpty{
                        // Update an existing diary.
                        diaries[selectedIndexPath[0].row] = diary
                        collectionView?.reloadItems(at: selectedIndexPath)
                    }
                    else {
                        // Add a new diary
                        diaries.insert(diary, at: 0)
                        collectionView?.insertItems(at: [IndexPath(row: 0, section: 0)])
                    }
                }
            }
        }
    }
    
    
    // MARK: Private Methods
    
    private func loadSampleDiaries() {
        
        guard let diary1 = Diary(content: "Just to see what will happen when the content is really really really really really long hhhhhhhhh", photos: nil, mood: 90, date: Date(), tag: "test") else {
            fatalError("Unable to instantiate diary1")
        }
        
        guard let diary2 = Diary(content: "ios太难了", photos: nil, mood: 65, date: Date(), tag: "study") else {
            fatalError("Unable to instantiate diary2")
        }
        
        guard let diary3 = Diary(content: "室友都睡了", photos: nil, mood: 10, date: Date(), tag: "life") else {
            fatalError("Unable to instantiate diary3")
        }
        diaries+=[diary1, diary2, diary3]
        
    }
    
    private func setupUILayout() {
        let itemSize = WIDTH / 2 - 10
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        self.collectionView!.setCollectionViewLayout(layout, animated: true)
    }

}
