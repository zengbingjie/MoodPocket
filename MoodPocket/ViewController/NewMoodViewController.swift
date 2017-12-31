//
//  NewMoodViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/4.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit
import os.log

class NewMoodViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // MARK: Properties
    //save
    @IBOutlet weak var saveButton: UIBarButtonItem!
    //choose the date
    @IBOutlet weak var dateTextButton: UIButton!
    var datePicked = Date()
    @IBOutlet weak var editDateButton: UIButton!
    //choose the photo, favourite
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var moodTagImage: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    //input
    @IBOutlet weak var contentTextView: UITextView!
    //set the mood value
    @IBOutlet weak var moodValueSlider: UISlider!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var moodSliderView: UIView!
    //choose the tag
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var cancelChooseTagButton: UIButton!
    @IBOutlet weak var saveChooseTagButton: UIButton!
    @IBOutlet weak var chosenTagLabel: UILabel!
    @IBOutlet weak var chooseTagView: ChooseTagView!
    @IBOutlet weak var newTagTextField: UITextField!
    
    //add a tag
    var TAG_VIEW_MODE = "CHOOSE"
    var newTag = ""
    var lastChosenTag = ""
    
    var diary: Diary?
//    var diaryIndex: Int?
//    var collectionView: UICollectionView?
    
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
    
    @IBAction func newTagButtonTapped(_ sender: UIButton) {
        TAG_VIEW_MODE = "NEW"
        newTagTextField.text = ""
        tagTableView.isHidden = true
        newTagTextField.isHidden = false
        newTagTextField.becomeFirstResponder()
        saveChooseTagButton.isEnabled = false
    }
    
    
    @IBAction func cancelChooseTag(_ sender: UIButton) {
        if TAG_VIEW_MODE=="NEW"{
            newTagTextField.resignFirstResponder()
            newTagTextField.isHidden = true
            tagTableView.isHidden = false
            TAG_VIEW_MODE = "CHOOSE"
        } else { // "CHOOSE"
            chooseTagView.isHidden = true
            chosenTagLabel.text = diary?.tag
        }
        chosenTagLabel.text = lastChosenTag
    }
    
    @IBAction func saveChooseTag(_ sender: UIButton) {
        if TAG_VIEW_MODE=="NEW"{
            newTagTextField.resignFirstResponder()
            newTagTextField.isHidden = true
            tagTableView.isHidden = false
            config.tags += [newTagTextField.text!]
            tagTableView.reloadData()
            TAG_VIEW_MODE = "CHOOSE"
        } else { // "CHOOSE"
            chooseTagView.isHidden = true
            //chosenTagLabel.text = chosenTag
        }
        lastChosenTag = chosenTagLabel.text!
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        contentTextView.resignFirstResponder()
        let isPresentingInAddDiaryMode = presentingViewController is UITabBarController
        if isPresentingInAddDiaryMode { // 添加新日记
            // 如果已经有写东西/添加照片，显示放弃/取消
            if ((contentTextView.hasText && contentTextView.textColor==UIColor.black) || photoImageView.image != #imageLiteral(resourceName: "defaultimage")){
                let cancelSheet = UIAlertController(title: nil, message: nil, preferredStyle:.actionSheet)
                let giveupAlertAction = UIAlertAction(title: "Give up", style: UIAlertActionStyle.destructive, handler: {action in
                    self.dismiss(animated: true, completion: nil)
                })
                cancelSheet.addAction(giveupAlertAction)
                let cancelAlertAction = UIAlertAction(title:"Cancel",style :.cancel, handler: nil)
                cancelSheet.addAction(cancelAlertAction)
                present(cancelSheet, animated: true, completion: nil)
            } else {
                // 否则，直接dismiss
                dismiss(animated: true, completion: nil)
            }
        } else if let owningNavigationController = navigationController{ // 编辑已有日记
            // 显示返回/删除/取消
            let cancelSheet = UIAlertController(title: nil, message: nil, preferredStyle:.actionSheet)
            let backAlertAction = UIAlertAction(title:"Back",style :.default, handler: {action in
                owningNavigationController.popViewController(animated: true)
            })
            cancelSheet.addAction(backAlertAction)
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
                    /*
                    diaries.remove(at: self.diaryIndex!)
                    self.collectionView?.deleteItems(at: [IndexPath(row: self.diaryIndex!, section: letters.isEmpty ? 0 : 1)])
                    self.collectionView?.reloadData()
                    Diary.saveDiaries()
 */
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
            
        } else {
            fatalError("The NewMoodViewController is not inside a navigation controller.")
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
            let datePicker = UIDatePicker(frame: CGRect(x:0, y:dateTextButton.frame.maxY, width:WIDTH, height:0))
            datePicker.maximumDate = Date()
            datePicker.datePickerMode = UIDatePickerMode.date
            datePicker.setDate(datePicked, animated: true)
            
            //datePicker.locale = Locale(identifier: "zh_CN") // 设置为中文
            datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            editDateButtonMore = false
            editDateButton.setImage(#imageLiteral(resourceName: "up"), for: UIControlState.normal)
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
            editDateButton.setImage(#imageLiteral(resourceName: "down"), for: UIControlState.normal)
        }
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        let photoSheet = UIAlertController(title: nil, message: nil, preferredStyle:.actionSheet)
        if photoImageView.image != #imageLiteral(resourceName: "defaultimage") {
            let checkPhotoAction = UIAlertAction(title: "See Photo", style: .default, handler: {action in
                self.performSegue(withIdentifier: "ShowPhoto", sender: self)
            })
            photoSheet.addAction(checkPhotoAction)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {action in
            self.chooseTagView.isHidden = true
            self.contentTextView.resignFirstResponder()
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        })
        photoSheet.addAction(photoLibraryAction)
        if photoImageView.image != #imageLiteral(resourceName: "defaultimage") {
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {action in
                self.photoImageView.image = #imageLiteral(resourceName: "defaultimage")
            })
            photoSheet.addAction(deleteAction)
        }
        let cancelAlertAction = UIAlertAction(title:"Cancel",style :.cancel, handler: nil)
        photoSheet.addAction(cancelAlertAction)
        present(photoSheet, animated: true, completion: nil)
    }
    
    @IBAction func tagButtonTapped(_ sender: UIButton) {
        if !chooseTagView.isHidden {
            chooseTagView.isHidden = true
        } else {
            chooseTagView.isHidden = false
            let x = chooseTagView.frame.minX
            let y = chooseTagView.frame.minY
            let h = chooseTagView.frame.height
            let w = chooseTagView.frame.width
            let tx = tagTableView.frame.minX
            let ty = tagTableView.frame.minY
            let th = tagTableView.frame.height
            let tw = tagTableView.frame.width
            chooseTagView.frame = CGRect(x: x, y: y, width: w, height: 0)
            tagTableView.frame = CGRect(x: tx, y: ty, width: tw, height: 0)
            UIView.animate(withDuration: 0.2, animations: {
                self.chooseTagView.frame = CGRect(x:x, y:y, width:w, height:h)
                self.tagTableView.frame = CGRect(x:tx, y:ty, width:tw, height:th)
            }, completion: nil)
            contentTextView.resignFirstResponder()
            //tagTableView.reloadData()
        }
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
                fatalError("The dequeued cell is not an instance of tagCell.")
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
        if (indexPath.section==0){
            //chosenTag = (tableView.cellForRow(at: indexPath) as! TagTableViewCell).tagLabel.text!
            chosenTagLabel.text = (tableView.cellForRow(at: indexPath) as! TagTableViewCell).tagLabel.text!
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath.section==1){
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if (indexPath.section==0){
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            config.tags.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Config.saveConfig()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: TextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        if newText.length==0 {
            saveChooseTagButton.isEnabled = false
        } else {
            saveChooseTagButton.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        checkSaveButtonState()
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
        editDateButton.setImage(#imageLiteral(resourceName: "down"), for: UIControlState.normal)
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
        
        switch(segue.identifier ?? "")
        {
        case "ShowPhoto":
            guard let photoDetailViewController = segue.destination as? CheckPhotoViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            photoDetailViewController.image = self.photoImageView.image
        case "EnterPwd": break
        default:
            guard let button = sender as? UIBarButtonItem, button === saveButton else {
                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
                return
            }
            
            var content = contentTextView.text
            if contentTextView.textColor==UIColor.lightGray{
                content = ""
            }
            let date = datePicked
            let mood = moodValueSlider.value
            let photo = photoImageView.image
            let tag = chosenTagLabel.text
            let isFavourite = favouriteButton.isSelected
            diary = Diary(content: content!, photo: photo!, mood: Int(mood), date: date, tag: tag, isFavourite: isFavourite)
        }
    }
    
    // MARK: Slider Delegate
    
    @objc func moodValueChanged() {
        chooseTagView.isHidden = true
        sliderValueLabel.text = String(Int(moodValueSlider.value))
        if moodValueSlider.value<33 {
            moodSliderView.backgroundColor = COLORS[4]
            moodTagImage.image = #imageLiteral(resourceName: "colorfulbadmood")
        } else if moodValueSlider.value<66 {
            moodSliderView.backgroundColor = COLORS[6]
            moodTagImage.image = #imageLiteral(resourceName: "nomood")
        } else {
            moodSliderView.backgroundColor = COLORS[0]
            moodTagImage.image = #imageLiteral(resourceName: "colorfulgoodmood")
        }
    }
    
    @objc func moodValueComfirmed() {
        sliderValueLabel.text = ""
    }
    
    // MARK: DatePicker Delegate
    
    @objc func dateChanged(datePicker : UIDatePicker){
        dateTextButton.setTitle(datePicker.date.toString(), for: .normal)
        datePicked = datePicker.date
    }
    
    // MARK: Private Methos
    
    private func setupUILayout(){
        dateTextButton.setTitle(datePicked.toString(), for: .normal)
        sliderValueLabel.text = ""
        if let diary = self.diary { // editing mood
            navigationItem.title = "Edit Mood"
            dateTextButton.setTitle(diary.date.toString(), for: .normal)
            datePicked = diary.date
            contentTextView.text = diary.content
            contentTextView.textColor = UIColor.black
            photoImageView.image = diary.photo
            if diary.mood<33 {
                moodTagImage.image = #imageLiteral(resourceName: "colorfulbadmood")
            } else if diary.mood<66 {
                moodTagImage.image = #imageLiteral(resourceName: "nomood")
            } else {
                moodTagImage.image = #imageLiteral(resourceName: "colorfulgoodmood")
            }
            favouriteButton.isSelected = diary.isFavourite
            chosenTagLabel.text = diary.tag
            lastChosenTag = diary.tag!
            moodValueSlider.setValue(Float(diary.mood), animated: false)
        } else {
            contentTextView.text = "这一刻的想法..."
            contentTextView.textColor = UIColor.lightGray
            chosenTagLabel.text = ""
            lastChosenTag = ""
        }
        checkSaveButtonState()
        addToolBar()
        moodSliderView.backgroundColor = COLORS[6]
        contentTextView.layoutManager.allowsNonContiguousLayout = false
        chooseTagView.isHidden = true
        newTagTextField.isHidden = true
        
    }
    
    private func checkSaveButtonState(){
        saveButton.isEnabled = contentTextView.hasText && (contentTextView.textColor==UIColor.black || photoImageView.image != #imageLiteral(resourceName: "defaultimage"))
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
        newTagTextField.delegate = self
        favouriteButton.setImage(#imageLiteral(resourceName: "heartshape"), for: .normal)
        favouriteButton.setImage(#imageLiteral(resourceName: "filledheartshape"), for: .selected)
        favouriteButton.setImage(#imageLiteral(resourceName: "heartshape"), for: [.highlighted, .selected])
        editDateButtonMore = true
        moodValueSlider.addTarget(self, action: #selector(moodValueChanged), for: .touchDragInside)
        moodValueSlider.addTarget(self, action: #selector(moodValueComfirmed), for: .touchUpInside)
    }

}
