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
            
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    print("Error authenticating \(e)")
                    self.loginError.text = e.localizedDescription
                } else {
                    self.db.collection("users").addSnapshotListener { (querrySnapshot, error) in
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
    }
}
