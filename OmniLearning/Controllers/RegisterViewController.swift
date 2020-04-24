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
    @IBOutlet weak var registerButton: UIButton!
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
        
        registerButton.layer.cornerRadius = 30
        registerButton.clipsToBounds = true
        
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        if let email = email.text, let password = password.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let e = error {
                    self.registerError.text = e.localizedDescription
                } else {
                    if let matchEmail = self.mentorOrStudentEmail.text {
                        var ref: DocumentReference? = nil
                        ref = self.db.collection("users").addDocument(data: [
                            "matchEmail": matchEmail,
                            "userType": self.userType
                        ]) { (error) in
                            if let e = error {
                                print("There was an issue saving mentor/student email and user type to firestore, \(e.localizedDescription)")
                            } else {
                                print("Successfully saved with ID: \(ref!.documentID)")
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
                                if savedUserType == "Mentor" {
                                    self.performSegue(withIdentifier: "goToMentor", sender: self)
                                } else if savedUserType == "Student" {
                                    self.performSegue(withIdentifier: "goToStudent", sender: self)
                                } else {
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
        //        defaults.set(RegisterViewController.userType, forKey: "userType")
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

