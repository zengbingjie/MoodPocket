//
//  SecurityTableViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/21.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit
import os.log

class SecurityTableViewController: UITableViewController {

    @IBOutlet weak var pwdSwitcher: UISwitch!
    
    @IBOutlet weak var modifyPasswordCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        pwdSwitcher.isOn = config.NEED_PWD
        modifyPasswordCell.isUserInteractionEnabled = config.NEED_PWD
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
        return 2
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row==1 {
            if pwdSwitcher.isOn{
                config.PWD_VIEW_MODE = "MODIFY"
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "")
        {
        case "ModifyPwd":
            config.PWD_VIEW_MODE = "MODIFY"
        case "OnOffPwd":
            modifyPasswordCell.isUserInteractionEnabled = config.NEED_PWD
            pwdSwitcher.setOn(config.NEED_PWD, animated: true)
            guard let passwordViewController = ((segue.destination as? UINavigationController)?.topViewController) as? EnterPasswordUIViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            passwordViewController.pwdSwitcher = self.pwdSwitcher
            passwordViewController.modifyPasswordCell = self.modifyPasswordCell
        case "EnterPwd": break
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: Action
    
    @IBAction func pwdSwitcherTapped(_ sender: UISwitch) {
        if pwdSwitcher.isOn {
            config.PWD_VIEW_MODE = "SWITCHOFF"
        } else {
            config.PWD_VIEW_MODE = "NEW"
        }
        performSegue(withIdentifier: "OnOffPwd", sender: self)
    }
    
}
