//
//  CheckLetterViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/27.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit

class CheckLetterViewController: UIViewController {

    @IBOutlet weak var sendDateLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    var letter: Letter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sendDateLabel.text = letter?.sendDate.toString()
        contentTextView.text = letter?.content
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

}
