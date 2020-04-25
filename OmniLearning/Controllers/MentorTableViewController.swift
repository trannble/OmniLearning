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
    
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var incentive: UITextField!
    @IBOutlet weak var taskTableView: UITableView!
    
    
    var task: [Task] = [
        Task(sender: "a@b.com", message: "Do KhanAcademy", time: "9:00AM")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDate.text = "Today is \(getCurrentDate())"
        taskTableView.dataSource = self
        taskTableView.delegate = self
        
        //reuse nib
        
        //loadTasks()
    }
    
    func getCurrentDate() -> String {
        let currentDate = Date()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        let dateTimeString = formatter.string(from: currentDate)
        
        return dateTimeString
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
    }
    
    /* func loadTask() {
    
    } */
    
    /*func 
 
     */

}

extension MentorTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath)
        cell.textLabel?.text = task[indexPath.row].message
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
}


