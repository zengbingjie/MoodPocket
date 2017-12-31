//
//  MailBoxViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/27.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit

class MailBoxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var letterTableView: UITableView!
    var  unreadLetters: [Letter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        letterTableView.delegate = self
        letterTableView.dataSource = self
        getUnreadLetters()
        letterTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action

    
    // MARK: TableView Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unreadLetters.count
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let deleteLetter = unreadLetters[indexPath.row]
            for index in 0..<letters.count{
                if letters[index] == deleteLetter{
                    letters.remove(at: index)
                    break
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            Letter.saveLetters()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LetterTableCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LetterTableViewCell  else {
            fatalError("The dequeued cell is not an instance of LetterTableCell.")
        }
        cell.sendDateLabel.text = unreadLetters[indexPath.row].sendDate.toString()
        cell.contentLabel.text = unreadLetters[indexPath.row].content
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "")
        {
        case "ShowLetterDetail":
            guard let letterDetailViewController = segue.destination as? CheckLetterViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedLetterCell = sender as? LetterTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = letterTableView?.indexPath(for: selectedLetterCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedLetter = unreadLetters[indexPath.row]
            letterDetailViewController.letter = selectedLetter
            unreadLetters.remove(at: indexPath.row)
            for index in 0..<letters.count {
                if letters[index] == selectedLetter{
                    letters.remove(at: index)
                    break
                }
            }
            letterTableView.deleteRows(at: [indexPath], with: .fade)
            Letter.saveLetters()
            let notification = Notification(name: NSNotification.Name(rawValue: "lettersUpdated"), object: self, userInfo: nil)
            notificationCenter.post(notification)
        case "EnterPwd": break
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

    // MARK: Private Methods
    
    private func getUnreadLetters() {
        for letter in letters {
            if letter.receiveDate.toString() <= Date().toString(){
                unreadLetters.append(letter)
            }
        }
    }
    
}
