//
//  NewMoodViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/4.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit
import os.log

class NewMoodViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

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
    
    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var cancelChooseTagButton: UIButton!
    @IBOutlet weak var saveChooseTagButton: UIButton!
    @IBOutlet weak var chosenTagLabel: UILabel!
    @IBOutlet weak var chooseTagView: ChooseTagView!
    
    var chosenTag = ""
    
    var diary: Diary?
    
    private var editDateButtonMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializingWork()
        setupUILayout()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func cancelChooseTag(_ sender: UIButton) {
        chooseTagView.isHidden = true
    }
    
    @IBAction func saveChooseTag(_ sender: UIButton) {
        chooseTagView.isHidden = true
        chosenTagLabel.text = chosenTag
    }
    
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
        chooseTagView.isHidden = true
        if editDateButtonMore {
            contentTextView.resignFirstResponder()
            photoImageView.isHidden = true
            moodTagImage.isHidden = true
            tagButton.isHidden = true
            favouriteButton.isHidden = true
            contentTextView.isHidden = true
            chooseTagView.isHidden = true
            chosenTagLabel.isHidden = true
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
        chooseTagView.isHidden = true
        contentTextView.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //TODO:
    
    @IBAction func tagButtonTapped(_ sender: UIButton) {
        chooseTagView.isHidden = false
        let x = chooseTagView.frame.minX
        let y = chooseTagView.frame.minY
        let h = chooseTagView.frame.height
        let w = chooseTagView.frame.width
        chooseTagView.frame = CGRect(x: x, y: y, width: w, height: 0)
        UIView.animate(withDuration: 0.2, animations: {
            self.chooseTagView.frame = CGRect(x:x, y:y, width:w, height:h)
        }, completion: nil)
        contentTextView.resignFirstResponder()
        tagTableView.reloadData()
    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        chooseTagView.isHidden = true
        if !sender.isSelected {
            sender.isSelected = true
        } else {
            sender.isSelected = false
        }
    }
    
    // MARK: TableView Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return config.tags.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as? TagTableViewCell  else {
                fatalError("The dequeued cell is not an instance of RecentTableViewCell.")
            }
            // Configure the cell...
            // Fetches the appropriate meal for the data source layout.
            cell.tagLabel.text = config.tags[indexPath.row]
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addTagCell", for: indexPath)
            return cell
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenTag = (tableView.cellForRow(at: indexPath) as! TagTableViewCell).tagLabel.text!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // MARK: UIImagePickerControllerDelegate
    
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
        chooseTagView.isHidden = true
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
        let tag = chosenTagLabel.text
        let isFavourite = favouriteButton.isSelected
        diary = Diary(content: content!, photo: photo, mood: Int(mood), date: date, tag: tag, isFavourite: isFavourite)
    }
    
    // MARK: Slider Delegate
    
    @objc func moodValueChanged() {
        chooseTagView.isHidden = true
        sliderValueLabel.text = String(Int(moodValueSlider.value))
        if moodValueSlider.value<33 {
            moodSliderView.backgroundColor = COLORS[4]
            moodTagImage.image = UIImage(named: "colorfulbadmood")
        } else if moodValueSlider.value<66 {
            moodSliderView.backgroundColor = COLORS[6]
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
    
    private func setupUILayout(){
        dateLabel.text = datePicked.toString()
        sliderValueLabel.text = ""
        if let diary = self.diary { // editing mood
            navigationItem.title = "Edit Mood"
            dateLabel.text = diary.date.toString()
            datePicked = diary.date
            contentTextView.text = diary.content
            contentTextView.textColor = UIColor.black
            photoImageView.image = diary.photo
            favouriteButton.isSelected = diary.isFavourite
            chosenTagLabel.text = diary.tag
            moodValueSlider.setValue(Float(diary.mood), animated: false)
        } else {
            contentTextView.text = "这一刻的想法..."
            contentTextView.textColor = UIColor.lightGray
            chosenTagLabel.text = ""
        }
        checkSaveButtonState()
        addToolBar()
        moodSliderView.backgroundColor = COLORS[6]
        contentTextView.layoutManager.allowsNonContiguousLayout = false
        chooseTagView.isHidden = true
        
    }
    
    private func checkSaveButtonState(){
        saveButton.isEnabled = contentTextView.hasText && contentTextView.textColor==UIColor.black
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
    
    private func initializingWork() {
        contentTextView.delegate = self
        tagTableView.delegate = self
        tagTableView.dataSource = self
        favouriteButton.setImage(#imageLiteral(resourceName: "heartshape"), for: .normal)
        favouriteButton.setImage(#imageLiteral(resourceName: "filledheartshape"), for: .selected)
        favouriteButton.setImage(#imageLiteral(resourceName: "heartshape"), for: [.highlighted, .selected])
        editDateButtonMore = true
        moodValueSlider.addTarget(self, action: #selector(moodValueChanged), for: .touchDragInside)
        moodValueSlider.addTarget(self, action: #selector(moodValueComfirmed), for: .touchUpInside)
    }

}
