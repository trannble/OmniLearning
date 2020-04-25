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
    @IBOutlet weak var studentLogIn: UIButton!
    @IBOutlet weak var mentorLogIn: UIButton!
    @IBOutlet weak var loginError: UILabel!
    
    var savedEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.layer.cornerRadius = 20
        email.clipsToBounds = true
        
        password.layer.cornerRadius = 20
        password.clipsToBounds = true
        
        studentLogIn.layer.cornerRadius = 20
        studentLogIn.clipsToBounds = true
        
        mentorLogIn.layer.cornerRadius = 20
        mentorLogIn.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToStudentFromLogIn" {
            let destinationVC = segue.destination as! StudentTableViewController
            destinationVC.email = savedEmail
        } else if segue.identifier == "goToMentorFromLogIn" {
            let destinationVC = segue.destination as! MentorTableViewController
            destinationVC.email = savedEmail
        }
        
    }
    
//MARK: - Student Log In Button
    
    @IBAction func studentLogInButtonPressed(_ sender: UIButton) {
        
        if let email = email.text, let password = password.text {
            
            savedEmail = email
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else {return}
                if let e = error {
                    print("Error authenticating \(e)")
                    self.loginError.text = e.localizedDescription
                } else {
                    
                    self.performSegue(withIdentifier: "goToStudentFromLogIn", sender: self)

                    
//                    self.db.collection("users").getDocuments() { (querrySnapshot, error) in
//                        if let e = error {
//                            print("Error getting userType: \(e.localizedDescription)")
//                        } else {
//                            for document in querrySnapshot!.documents {
//                                let data = document.data()
//                                if let savedUserType = data["userType"] as? String {
//
//                                    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//                                        let destinationVC = segue.destination as! StudentTableViewController
//                                        destinationVC.email = email
//                                    }
//
//                                    self.performSegue(withIdentifier: "goToStudentFromLogIn", sender: self)
//                                }
//                            }
//                        }
//                    }
                }
            }
        }
    }
        
//MARK: - Mentor Button Pressed
        
    @IBAction func mentorLogInButtonPressed(_ sender: UIButton) {
        
        if let email = email.text, let password = password.text {
            
            savedEmail = email
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else {return}
                if let e = error {
                    print("Error authenticating \(e)")
                    self.loginError.text = e.localizedDescription
                } else {
                    self.performSegue(withIdentifier: "goToMentorFromLogIn", sender: self)

//                    self.db.collection("users").getDocuments() { (querrySnapshot, error) in
//                        if let e = error {
//                            print("Error getting userType: \(e.localizedDescription)")
//                        } else {
//                            for document in querrySnapshot!.documents {
//                                let data = document.data()
//                                if let savedUserType = data["userType"] as? String {
//
//                                    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//                                        let destinationVC = segue.destination as! MentorTableViewController
//                                        destinationVC.email = email
//                                    }
//
//                                    self.performSegue(withIdentifier: "goToMentorFromLogIn", sender: self)
//                                }
//                            }
//                        }
//                    }
                }
            }
        }
    }
}

