//
//  RegisterViewController.swift
//  OmniLearning
//
//  Created by Tran Le on 4/21/20.
//  Copyright © 2020 TL Inc. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerError: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    
    fileprivate var pickerData = ["Student", "Mentor"]
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
        
        registerButton.layer.cornerRadius = 30
        registerButton.clipsToBounds = true
        
        icon.layer.cornerRadius = 30
        icon.clipsToBounds = true
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
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
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()

            pickerLabel?.font = UIFont(name: "System Thin", size: 30)
            pickerLabel?.font = UIFont.systemFont(ofSize: 30)
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.textColor = UIColor(named: "DarkPurple")
        }

        pickerLabel?.text = pickerData[row]

        return pickerLabel!;
    }
}
