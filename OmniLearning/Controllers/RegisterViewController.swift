//
//  RegisterViewController.swift
//  OmniLearning
//
//  Created by Tran Le on 4/21/20.
//  Copyright © 2020 TL Inc. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    @IBOutlet weak var mentorEmail: UITextField! //mentorEmail.text might not have value --> use optional binding
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerError: UILabel!
    
    let defaults = UserDefaults.standard //only storing userType and mentorEmail
    
    var pickerData = ["Student", "Mentor"]
    fileprivate var userType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userTypePickerView.delegate = self
        self.userTypePickerView.dataSource = self
        
        //styling
        email.layer.cornerRadius = 20
        email.clipsToBounds = true
        
        userTypePickerView.layer.cornerRadius = 30
        userTypePickerView.clipsToBounds = true
        
        password.layer.cornerRadius = 20
        password.clipsToBounds = true
        
        mentorEmail.layer.cornerRadius = 20
        mentorEmail.clipsToBounds = true
        
        registerButton.layer.cornerRadius = 30
        registerButton.clipsToBounds = true
        
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        if let mentorEmail = mentorEmail {
            defaults.set(mentorEmail, forKey: "mentorEmail")
        }
        
        if let email = email.text, let password = password.text {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let e = error {
                    self.registerError.text = e.localizedDescription
                    print(e.localizedDescription)
                } else {
                    if self.userType == "Mentor" {
                        self.performSegue(withIdentifier: "goToMentor", sender: self)
                    } else if self.userType == "Student" {
                        self.performSegue(withIdentifier: "goToStudent", sender: self)
                    }
                }
            }
        }
    }
}



//MARK: - Picker View

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userType = pickerData[row]
        defaults.set(userType, forKey: "userType")
        if userType == "Mentor"{
            DispatchQueue.main.async {
                self.mentorEmail.isHidden = true
            }
        } else {
            DispatchQueue.main.async {
                self.mentorEmail.isHidden = false
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "System Thin", size: 30)
            pickerLabel?.font = UIFont.systemFont(ofSize: 30)
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.textColor = UIColor(named: "Yellow")
        }
        
        pickerLabel?.text = pickerData[row]
        
        userType = pickerData[row]
        
        return pickerLabel!;
    }
}
