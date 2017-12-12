//
//  RecentTableViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/5.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit
import os.log

class RecentTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var diaries = [Diary]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadSampleDiaries()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return diaries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RecentTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecentTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RecentTableViewCell.")
        }
        
        // Configure the cell...
        
        // Fetches the appropriate meal for the data source layout.
        
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
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            diaries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddDiary":
            os_log("Adding a new diary.", log: OSLog.default, type: .debug)
        case "ShowDiaryDetail":
            guard let diaryDetailViewController = segue.destination as? NewMoodViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDiaryCell = sender as? RecentTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedDiaryCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedDiary = diaries[indexPath.row]
            diaryDetailViewController.diary = selectedDiary
        case "AddLetter": break
        case "ShowCalendarView": break
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: Actions
    
    @IBAction func unwindToRecentList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewMoodViewController {
            sourceViewController.contentTextView.resignFirstResponder()
            if let diary = sourceViewController.diary {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    // Update an existing diary.
                    diaries[selectedIndexPath.row] = diary
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                } else {
                    // Add a new diary
                    diaries.insert(diary, at: 0)
                    tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
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

}
