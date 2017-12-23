//
//  NewMoodViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/4.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit
import os.log

class NewMoodViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var dateLabel: UILabel!
    var datePicked = Date()
    @IBOutlet weak var editDateButton: UIButton!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var moodTagImage: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var moodValueSlider: UISlider!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var moodSliderView: UIView!
    
    var diary: Diary?
    
    private var editDateButtonMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        contentTextView.delegate = self
        setupLabel()
        editDateButtonMore = true
        if let diary = self.diary { // editing mood
            navigationItem.title = "Edit Mood"
            dateLabel.text = diary.date.toString()
            datePicked = diary.date
            contentTextView.text = diary.content
            contentTextView.textColor = UIColor.black
            photoImageView.image = diary.photo
            moodValueSlider.setValue(Float(diary.mood), animated: false)
        } else {
            contentTextView.text = "这一刻的想法..."
            contentTextView.textColor = UIColor.lightGray
        }
        checkSaveButtonState()
        addToolBar()
        moodSliderView.backgroundColor = COLORS[3]
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
            photoImageView.isHidden = true
            moodTagImage.isHidden = true
            tagButton.isHidden = true
            favouriteButton.isHidden = true
            contentTextView.isHidden = true
            //创建日期选择器
            let datePicker = UIDatePicker(frame: CGRect(x:0, y:104, width:WIDTH, height:0))
            datePicker.datePickerMode = UIDatePickerMode.date
            datePicker.setDate(datePicked, animated: true)
            
            //datePicker.locale = Locale(identifier: "zh_CN") // 设置为中文
            datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            editDateButtonMore = false
            sender.setImage(UIImage(named: "up"), for: UIControlState.normal)
            self.view.addSubview(datePicker)
            UIView.animate(withDuration: 0.2, animations: {
                datePicker.frame = CGRect(x:0, y:104, width:WIDTH, height:216)
            }, completion: nil)
            contentTextView.isHidden = true
        } else {
            photoImageView.isHidden = false
            moodTagImage.isHidden = false
            tagButton.isHidden = false
            favouriteButton.isHidden = false
            contentTextView.isHidden = false
            //删除datePicker子视图
            for subview in self.view.subviews{
                if subview is UIDatePicker {
                    subview.removeFromSuperview()
                    break
                }
            }
            editDateButtonMore = true
            sender.setImage(UIImage(named: "down"), for: UIControlState.normal)
            contentTextView.isHidden = false
        }
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        contentTextView.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: contentTextView Delegate
    
    func textViewDidChange(_ textView: UITextView) {
        checkSaveButtonState()
        let allStrCount = textView.text.count //获取总文字个数
        textView.scrollRangeToVisible(NSMakeRange(0, allStrCount))//把光标位置移到最后
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if contentTextView.textColor==UIColor.lightGray{
            contentTextView.text = ""
            contentTextView.textColor = UIColor.black
        }
        //textView.zoom(to: CGRect(x:16, y:156, width:WIDTH-32, height:HEIGHT-156-350), animated: false)
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !contentTextView.hasText {
            contentTextView.text = "这一刻的想法..."
            contentTextView.textColor = UIColor.lightGray
        }
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
        let photo = photoImageView.image
        // TODO: Tag
        let isFavourite = (favouriteButton.currentImage==UIImage(named: "filledheartshape"))
        diary = Diary(content: content!, photo: photo, mood: Int(mood), date: date, tag: nil, isFavourite: isFavourite)
    }
    
    // MARK: Slider Delegate
    
    @objc func moodValueChanged() {
        sliderValueLabel.text = String(Int(moodValueSlider.value))
        if moodValueSlider.value<33 {
            moodSliderView.backgroundColor = COLORS[4]
            moodTagImage.image = UIImage(named: "colorfulbadmood")
        } else if moodValueSlider.value<66 {
            moodSliderView.backgroundColor = COLORS[3]
            moodTagImage.image = UIImage(named: "nomood")
        } else {
            moodSliderView.backgroundColor = COLORS[0]
            moodTagImage.image = UIImage(named: "colorfulgoodmood")
        }
    }
    
    @objc func moodValueComfirmed() {
        sliderValueLabel.text = ""
    }
    
    // MARK: DatePicker Delegate
    
    @objc func dateChanged(datePicker : UIDatePicker){
        dateLabel.text = datePicker.date.toString()
        datePicked = datePicker.date
    }
    
    // MARK: Private Methos
    
    private func setupLabel(){
        dateLabel.text = datePicked.toString()
        sliderValueLabel.text = ""
    }
    
    private func checkSaveButtonState(){
        saveButton.isEnabled = contentTextView.hasText
    }
    
    @objc func doneButtonTapped() {
        contentTextView.resignFirstResponder()
        contentTextView.zoom(to: CGRect(x:16, y:156, width:WIDTH-32, height:HEIGHT-140), animated: false)
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
