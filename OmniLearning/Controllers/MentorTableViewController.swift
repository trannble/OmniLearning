//
//  MentorTableViewController.swift
//  OmniLearning
//
//  Created by Tran Le on 4/22/20.
//  Copyright © 2020 TL Inc. All rights reserved.
//

import UIKit
import Firebase

class MentorTableViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var task: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Mentor Dashboard: \(getCurrentDate())"
        
        //reuse nib
        
        //loadTasks()
        
    }
    
//    func getCurrentDate() -> String {
//        let currentDateTime = Date()
//        
//        let formatter = DateFormatter()
//        formatter.timeStyle = .medium
//        formatter.dateStyle = .long
//        
//        let dateTimeString = formatter.string(from: currentDateTime)
//        
//        return dateTimeString
//    }
    
    /* func loadTask() {
    
    } */
    
    /*func 
 
     */


}
