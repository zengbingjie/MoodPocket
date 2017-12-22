//
//  EnterPasswordUIViewController.swift
//  Mood Pocket
//
//  Created by 曾冰洁 on 2017/12/4.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit

class EnterPasswordUIViewController: UIViewController ,UITextFieldDelegate {
    
    // MARK: Properties

    //let passwordManager = PasswordManager()
    
    var pwdSwitcher: UISwitch?
    
    var modifyPasswordCell: UITableViewCell?
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var passwordTextFeild: UITextField!
    
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var passwordImage1: UIImageView!
    @IBOutlet weak var passwordImage2: UIImageView!
    @IBOutlet weak var passwordImage3: UIImageView!
    @IBOutlet weak var passwordImage4: UIImageView!
    
    var tempPassword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTextFeild.delegate = self
        passwordTextFeild.becomeFirstResponder()
        setupUILayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if PWD_VIEW_MODE=="SWITCHOFF" || PWD_VIEW_MODE=="NEW" {
            modifyPasswordCell?.isUserInteractionEnabled = NEED_PWD
            pwdSwitcher?.setOn(NEED_PWD, animated: true)
        }
        passwordTextFeild.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: TextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        if newText.length==0{
            passwordImage1.image = UIImage(named: "untypedpassword")
        } else if newText.length==1{
            passwordImage1.image = UIImage(named: "typedpassword")
            passwordImage2.image = UIImage(named: "untypedpassword")
        } else if newText.length==2{
            passwordImage1.image = UIImage(named: "typedpassword")
            passwordImage2.image = UIImage(named: "typedpassword")
            passwordImage3.image = UIImage(named: "untypedpassword")
        } else if newText.length==3{
            passwordImage2.image = UIImage(named: "typedpassword")
            passwordImage3.image = UIImage(named: "typedpassword")
            passwordImage4.image = UIImage(named: "untypedpassword")
        } else {
            passwordImage3.image = UIImage(named: "typedpassword")
            passwordImage4.image = UIImage(named: "typedpassword")
        }
        if newText.length==4 {
            if PWD_VIEW_MODE=="NEW" {
                tempPassword = newText as String
                hintLabel.text = "确认新密码"
                textField.text = ""
                passwordImage1.image = UIImage(named: "untypedpassword")
                passwordImage2.image = UIImage(named: "untypedpassword")
                passwordImage3.image = UIImage(named: "untypedpassword")
                passwordImage4.image = UIImage(named: "untypedpassword")
                PWD_VIEW_MODE = "NEWAGAIN"
                return false
            } else if  PWD_VIEW_MODE=="NEWAGAIN" {
                if newText as String==tempPassword {
                    PASSWORD = tempPassword
                    NEED_PWD = true
                    modifyPasswordCell?.isUserInteractionEnabled = true
                    pwdSwitcher?.setOn(true, animated: true)
                    textField.resignFirstResponder()
                    dismiss(animated: true, completion: nil)
                }
            } else { // "ENTER" "MODIFY" "SWITCHOFF"
                if newText as String==PASSWORD {
                    if PWD_VIEW_MODE=="ENTER" {
                        textField.resignFirstResponder()
                        dismiss(animated: true, completion: nil)
                    } else if PWD_VIEW_MODE=="SWITCHOFF"{
                        NEED_PWD = false
                        modifyPasswordCell?.isUserInteractionEnabled = false
                        pwdSwitcher?.setOn(false, animated: true)
                        textField.resignFirstResponder()
                        dismiss(animated: true, completion: nil)
                    } else { // "MODIFY"
                        hintLabel.text = "输入新密码"
                        textField.text = ""
                        passwordImage1.image = UIImage(named: "untypedpassword")
                        passwordImage2.image = UIImage(named: "untypedpassword")
                        passwordImage3.image = UIImage(named: "untypedpassword")
                        passwordImage4.image = UIImage(named: "untypedpassword")
                        PWD_VIEW_MODE = "NEW"
                        return false
                    }
                }
            }
        }
        return newText.length <= 4  //This means only five characters may be entered!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    fileprivate func setupUILayout() {
        if PWD_VIEW_MODE=="ENTER" {
            cancelButton.isEnabled = false
            hintLabel.text = "输入密码"
        } else if PWD_VIEW_MODE=="NEW" {
            cancelButton.isEnabled = true
            hintLabel.text = "输入新密码"
        }
        else { // "MODIFY" "SWITCHOFF"
            cancelButton.isEnabled = true
            hintLabel.text = "输入当前密码"
        }
    }

}
