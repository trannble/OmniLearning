//
//  LogInViewController.swift
//  OmniLearning
//
//  Created by Tran Le on 4/21/20.
//  Copyright © 2020 TL Inc. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.layer.cornerRadius = 20
        email.clipsToBounds = true
        
        password.layer.cornerRadius = 20
        password.clipsToBounds = true
        
        loginButton.layer.cornerRadius = 30
        loginButton.clipsToBounds = true
    
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if let email = email.text, let password = password.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else {return}
                if let e = error {
                    print("Error authenticating \(e)")
                    self.loginError.text = e.localizedDescription
                } else {
                    self.db.collection("users").getDocuments() { (querrySnapshot, error) in
                        if let e = error {
                            print("Error getting userType: \(e.localizedDescription)")
                        } else {
                                for document in querrySnapshot!.documents {
                                    let data = document.data()
                                    if let savedUserType = data["userType"] as? String {
                                        if savedUserType == "Mentor" {
                                            //print("Mentor was matched successfully")
                                            //print(savedUserType)
                                            self.performSegue(withIdentifier: "goToMentorFromLogIn", sender: self)
                                        } else if savedUserType == "Student" {
                                            self.performSegue(withIdentifier: "goToStudentFromLogIn", sender: self)
                                        } else {
                                            print("Error matching userType during login")
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
    }

