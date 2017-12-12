//
//  NewMoodViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/4.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit
import os.log

class NewMoodViewController: UIViewController, UITextViewDelegate {

    // MARK: Properties
    
    @IBOutlet weak var dateLabel: UILabel!
    var datePicked = Date()
    @IBOutlet weak var editDateButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var moodValueSlider: UISlider!
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    var diary: Diary?
    
    private var editDateButtonMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        contentTextView.delegate = self
        setupLabel()
        editDateButtonMore = true
        if let diary = self.diary {
            navigationItem.title = "Edit Mood"
            dateLabel.text = diary.date.toString()
            datePicked = diary.date
            contentTextView.text = diary.content
            moodValueSlider.setValue(Float(diary.mood), animated: false)
        }
        checkSaveButtonState()
        addToolBar()
        contentTextView.layoutManager.allowsNonContiguousLayout = false
        moodValueSlider.addTarget(self, action: #selector(moodValueChanged), for: .touchDragInside)
        moodValueSlider.addTarget(self, action: #selector(moodValueComfirmed), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        contentTextView.resignFirstResponder()
        let isPresentingInAddDiaryMode = presentingViewController is UITabBarController
        if isPresentingInAddDiaryMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
        
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editDateTapped(_ sender: UIButton) {
        if editDateButtonMore {
            contentTextView.resignFirstResponder()
            //创建日期选择器
            let datePicker = UIDatePicker(frame: CGRect(x:0, y:104, width:UIScreen.main.bounds.size.width, height:216))
            datePicker.datePickerMode = UIDatePickerMode.date
            datePicker.setDate(datePicked, animated: true)
            
            //将日期选择器区域设置为中文，则选择器日期显示为中文
            //datePicker.locale = Locale(identifier: "zh_CN")
            datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            editDateButtonMore = false
            sender.setImage(UIImage(named: "up"), for: UIControlState.normal)
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
            sender.setImage(UIImage(named: "down"), for: UIControlState.normal)
        }
    }
    
    // MARK: contentTextView Delegate
    
    func textViewDidChange(_ textView: UITextView) {
        checkSaveButtonState()
        let allStrCount = textView.text.count //获取总文字个数
        textView.scrollRangeToVisible(NSMakeRange(0, allStrCount))//把光标位置移到最后
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.zoom(to: CGRect(x:16, y:156, width:UIScreen.main.bounds.size.width-32, height:UIScreen.main.bounds.size.height-156-350), animated: false)
        //删除datePicker子视图
        for subview in self.view.subviews{
            if subview is UIDatePicker {
                subview.removeFromSuperview()
                break
            }
        }
        editDateButtonMore = true
        editDateButton.setImage(UIImage(named: "down"), for: UIControlState.normal)
        return true
    }
    
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let content = contentTextView.text
        let date = datePicked
        let mood = moodValueSlider.value
        diary = Diary(content: content!, photos: nil, mood: Int(mood), date: date, tag: nil)
    }
    
    // MARK: Private Methos
    
    private func setupLabel(){
        dateLabel.text = datePicked.toString()
        sliderValueLabel.text = ""
    }
    
    @objc func dateChanged(datePicker : UIDatePicker){
        dateLabel.text = datePicker.date.toString()
        datePicked = datePicker.date
    }
    
    private func checkSaveButtonState(){
        saveButton.isEnabled = contentTextView.hasText
    }
    
    @objc func doneButtonTapped() {
        contentTextView.resignFirstResponder()
        contentTextView.zoom(to: CGRect(x:16, y:156, width:UIScreen.main.bounds.size.width-32, height:UIScreen.main.bounds.size.height-140), animated: false)
    }
    
    @objc func moodValueChanged() {
        sliderValueLabel.text = String(Int(moodValueSlider.value))
    }
    
    @objc func moodValueComfirmed() {
        sliderValueLabel.text = ""
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
