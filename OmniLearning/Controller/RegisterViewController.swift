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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.layer.cornerRadius = 20
        email.clipsToBounds = true
        
        password.layer.cornerRadius = 20
        password.clipsToBounds = true
        
        registerButton.layer.cornerRadius = 30
        registerButton.clipsToBounds = true
        
        icon.layer.cornerRadius = 30
        icon.clipsToBounds = true
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
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
