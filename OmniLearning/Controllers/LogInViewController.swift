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
    
    var savedEmail = ""  //always the mentor email
    var userType = ""
    var studentEmail = ""
    
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
        
        guard let identifier = segue.identifier else { return }
        
        if identifier == "goToStudentFromLogIn" {
            let destinationVC = segue.destination as! StudentTableViewController
            destinationVC.email = savedEmail
            destinationVC.studentEmail = studentEmail
        } else if identifier == "goToMentorFromLogIn" {
            let destinationVC = segue.destination as! MentorTableViewController
            destinationVC.email = savedEmail
        }
    }
    
    //MARK: - Student Log In Button
    
    @IBAction func studentLogInButtonPressed(_ sender: UIButton) {
        
        if let email = email.text, let password = password.text {
            
            studentEmail = email
            
            db.collection("users").document(email).getDocument { (document, error) in
                if let document = document, document.exists {
                    if let dataDescription = document.data() {
                        self.savedEmail = dataDescription["matchEmail"] as! String
                        self.userType = dataDescription["userType"] as! String
                        
                        if self.userType == "Student" {
                            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                                guard let self = self else {return}
                                if let e = error {
                                    print("Error authenticating \(e)")
                                    self.loginError.text = e.localizedDescription
                                } else {
                                    
                                    self.performSegue(withIdentifier: "goToStudentFromLogIn", sender: self)
                                }
                            }
                        } else {
                            self.loginError.text = "You are not registered as a student."
                        }
                    }
                } else {
                    self.loginError.text = "Oh no! You are not registered with a mentor."
                }
            }
        }
    }
    
    //MARK: - Mentor Button Pressed
    
    @IBAction func mentorLogInButtonPressed(_ sender: UIButton) {
        
        if let email = email.text, let password = password.text {
            
            savedEmail = email
            
            db.collection("users").document(email).getDocument { (document, error) in
                if let document = document, document.exists {
                    if let dataDescription = document.data() {
                        self.userType = dataDescription["userType"] as! String
                        if self.userType == "Mentor" {
                            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                                guard let self = self else {return}
                                if let e = error {
                                    print("Error authenticating \(e)")
                                    self.loginError.text = e.localizedDescription
                                } else {
                                    self.performSegue(withIdentifier: "goToMentorFromLogIn", sender: self)
                                    
                                }
                            }
                        } else {
                            self.loginError.text = "You are not registered as a mentor."
                        }
                    }
                } else {
                    self.loginError.text = "Oh no! You are not registered with a mentor."
                }
            }
            
        }
    }
}

