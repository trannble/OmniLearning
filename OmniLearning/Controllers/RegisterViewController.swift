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
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    @IBOutlet weak var mentorOrStudentEmail: UITextField! 
    @IBOutlet weak var registerStudentButton: UIButton!
    @IBOutlet weak var registerMentorButton: UIButton!
    @IBOutlet weak var registerError: UILabel!
    
    
    var pickerData = ["Student", "Mentor"]
    var userType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //PickerView
        self.userTypePickerView.delegate = self
        self.userTypePickerView.dataSource = self
        
        //Styling
        email.layer.cornerRadius = 20
        email.clipsToBounds = true
        
        userTypePickerView.layer.cornerRadius = 30
        userTypePickerView.clipsToBounds = true
        
        password.layer.cornerRadius = 20
        password.clipsToBounds = true
        
        mentorOrStudentEmail.layer.cornerRadius = 20
        mentorOrStudentEmail.clipsToBounds = true
        
        registerStudentButton.layer.cornerRadius = 20
        registerStudentButton.clipsToBounds = true
        
        registerStudentButton.layer.cornerRadius = 20
        registerStudentButton.clipsToBounds = true
        
    }
    
    
    @IBAction func registerStudentButtonPressed(_ sender: UIButton) {
        
        if let email = email.text, let password = password.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let e = error {
                    self.registerError.text = e.localizedDescription
                } else {
                    if let matchEmail = self.mentorOrStudentEmail.text {
                        self.db.collection("users").document(email).setData ([
                            "matchEmail": matchEmail,
                            "userType": self.userType
                        ]) { (error) in
                            if let e = error {
                                print("There was an issue saving student email and user type to firestore, \(e.localizedDescription)")
                            } else {
                                print("Successfully saved with ID")
                            }
                        }
                    }
                }
            }
            
            
            db.collection("users").addSnapshotListener { (querrySnapshot, error) in
                
                if let e = error {
                    print("Error getting userType: \(e.localizedDescription)")
                } else {
                    if let snapshotDocuments = querrySnapshot?.documents {
                        for document in snapshotDocuments {
                            let data = document.data()
                            
                            if let savedUserType = data["userType"] as? String {
                                
                                func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
                                    if segue.identifier == "goToMentorFromRegister" {
                                        let destinationVC = segue.destination as! MentorTableViewController
                                        destinationVC.email = self.email.text!
                                    } else if segue.identifier == "goToStudentFromRegister" {
                                        let destinationVC = segue.destination as! StudentTableViewController
                                        destinationVC.email = self.email.text!
                                    }
                                }
                                
                                if savedUserType == "Mentor" {
                                    print(savedUserType)
                                    self.performSegue(withIdentifier: "goToMentorFromRegister", sender: self)
                                } else if savedUserType == "Student" {
                                    print(savedUserType)
                                    self.performSegue(withIdentifier: "goToStudentFromRegister", sender: self)
                                } else {
                                    print("Could not match database userType")
                                    return
                                }
                            }
                        }
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
        if userType == "Mentor"{
            DispatchQueue.main.async {
                self.mentorOrStudentEmail.placeholder = "Your Student's Email"
            }
        } else {
            DispatchQueue.main.async {
                self.mentorOrStudentEmail.placeholder = "Your Mentor's Email"
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

