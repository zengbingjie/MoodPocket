//
//  CheckDiaryViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/27.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit

class CheckDiaryViewController: UIViewController {

    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var moodImageView: UIImageView!
    
    var diary: Diary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let diary = self.diary {
            navigationTitle.title = diary.date.toString()
            contentTextView.text = diary.content
            contentTextView.textColor = UIColor.black
            photoImageView.image = diary.photo
            if diary.mood<33 {
                moodImageView.image = #imageLiteral(resourceName: "colorfulbadmood")
            } else if diary.mood<66 {
                moodImageView.image = #imageLiteral(resourceName: "nomood")
            } else {
                moodImageView.image = #imageLiteral(resourceName: "colorfulgoodmood")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func more(_ sender: UIBarButtonItem) {
        if let owningNavigationController = navigationController{
            let cancelSheet = UIAlertController(title: nil, message: nil, preferredStyle:.actionSheet)
            let deleteAlertAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: {action in
                cancelSheet.dismiss(animated: true, completion: nil)
                // 确认是否删除
                let confirmDelete = UIAlertController(title: "确定要删除吗?", message: nil, preferredStyle: .alert)
                let cancelDelete = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let okDelete = UIAlertAction(title: "OK", style: .destructive, handler: {
                    action in
                    // 删除
                    let notification = Notification(name: NSNotification.Name(rawValue: "diaryDeleted"), object: self, userInfo: nil)
                    notificationCenter.post(notification)
                    owningNavigationController.popViewController(animated: true)
                })
                confirmDelete.addAction(cancelDelete)
                confirmDelete.addAction(okDelete)
                self.present(confirmDelete, animated: true, completion: nil)
            })
            cancelSheet.addAction(deleteAlertAction)
            let cancelAlertAction = UIAlertAction(title:"Cancel",style :.cancel, handler: nil)
            cancelSheet.addAction(cancelAlertAction)
            present(cancelSheet, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
