//
//  LetterViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/6.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit

class LetterViewController: UIViewController, UITextViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var editDateButton: UIButton!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!
    
    private var editDateButtonMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentTextView.delegate = self
        setupDateLabel()
        editDateButtonMore = true
        checkSendButtonState()
        addToolBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        contentTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sned(_ sender: UIBarButtonItem) {
        contentTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editDateTapped(_ sender: UIButton) {
        if editDateButtonMore {
            contentTextView.resignFirstResponder()
            //创建日期选择器
            let datePicker = UIDatePicker(frame: CGRect(x:0, y:HEIGHT-276, width:WIDTH, height:216))
            datePicker.datePickerMode = UIDatePickerMode.date
            //将日期选择器区域设置为中文，则选择器日期显示为中文
            //datePicker.locale = Locale(identifier: "zh_CN")
            //注意：action里面的方法名后面需要加个冒号“：”
            datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            editDateButtonMore = false
            sender.setImage(UIImage(named: "down"), for: UIControlState.normal)
            self.view.addSubview(datePicker)
        } else {
            //删除datePicker子视图
            for subview in self.view.subviews{
                if subview is UIDatePicker {
                    subview.removeFromSuperview()
                    break
                }
            }
            editDateButtonMore = true
            sender.setImage(UIImage(named: "up"), for: UIControlState.normal)
        }
    }
    
    // MARK: contentTextView Delegate
    
    func textViewDidChange(_ textView: UITextView) {
        checkSendButtonState()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Private Methos
    
    private func setupDateLabel(){
        dateLabel.text = Date().toString()
    }
    
    @objc func dateChanged(datePicker : UIDatePicker){
        dateLabel.text = datePicker.date.toString()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        //删除datePicker子视图
        for subview in self.view.subviews{
            if subview is UIDatePicker {
                subview.removeFromSuperview()
                break
            }
        }
        editDateButtonMore = true
        editDateButton.setImage(UIImage(named: "up"), for: UIControlState.normal)
        return true
    }
    
    private func checkSendButtonState(){
        sendButton.isEnabled = contentTextView.hasText
    }
    
    @objc func doneButtonTapped() {
        contentTextView.resignFirstResponder()
    }
    
    private func addToolBar() {
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        contentTextView.inputAccessoryView = toolbar
    }

}
