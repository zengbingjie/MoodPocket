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

    let passwordManager = PasswordManager()
    
    @IBOutlet weak var passwordTextFeild: UITextField!
    
    @IBOutlet weak var passwordImage1: UIImageView!
    @IBOutlet weak var passwordImage2: UIImageView!
    @IBOutlet weak var passwordImage3: UIImageView!
    @IBOutlet weak var passwordImage4: UIImageView!
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTextFeild.delegate = self
        passwordTextFeild.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        if (newText.length==0){
            passwordImage1.image = UIImage(named: "untypedpassword")
        } else if (newText.length==1){
            passwordImage1.image = UIImage(named: "typedpassword")
            passwordImage2.image = UIImage(named: "untypedpassword")
        } else if (newText.length==2){
            passwordImage1.image = UIImage(named: "typedpassword")
            passwordImage2.image = UIImage(named: "typedpassword")
            passwordImage3.image = UIImage(named: "untypedpassword")
        } else if (newText.length==3){
            passwordImage2.image = UIImage(named: "typedpassword")
            passwordImage3.image = UIImage(named: "typedpassword")
            passwordImage4.image = UIImage(named: "untypedpassword")
        } else {
            passwordImage3.image = UIImage(named: "typedpassword")
            passwordImage4.image = UIImage(named: "typedpassword")
        }
        if (newText.length==4 && newText as String==passwordManager.password){
            textField.resignFirstResponder()
            dismiss(animated: true, completion: nil)
        }
        return newText.length <= 4 //This means only five characters may be entered!
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

}
