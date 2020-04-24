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
        
        if RegisterViewController.userType == "Mentor" {
            performSegue(withIdentifier: "goToMentor", sender: self)
        } else if
            RegisterViewController.self.userType == "Student" {
                self.performSegue(withIdentifier: "goToStudent", sender: self)
            }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
