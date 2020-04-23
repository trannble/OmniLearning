//
//  ViewController.swift
//  OmniLearning
//
//  Created by Tran Le on 4/21/20.
//  Copyright © 2020 TL Inc. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var OmniLearning: UILabel!
    
    @IBOutlet weak var Register: UIButton!
    
    @IBOutlet weak var LogIn: UIButton!
    
    
    //MARK: - View Settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OmniLearning.font = UIFont(name:  "Capriola-Regular", size: 43)
        
        OmniLearning.text = " "
        var charIndex = 0.0
        let titleText = "OMNILEARNING"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.OmniLearning.text?.append(letter)
            }
            charIndex += 1
        }
        
        Register.layer.cornerRadius = 20
        Register.clipsToBounds = true
        
        LogIn.layer.cornerRadius = 20
        LogIn.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    //MARK: - Redirect To Register or Log In
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
    }
    
    
    
}

