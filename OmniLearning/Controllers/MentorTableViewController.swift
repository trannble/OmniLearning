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
    @IBOutlet weak var errorMessage: UILabel!
    
    var email = ""
    var task: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDate.text = "Personalize your student's day: \(getCurrentDate())"
        taskTableView.dataSource = self
        
        taskTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "prototypeCell")
        
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
        
        var timeTextField = UITextField()
        var descriptionTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Assignment", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Assignment", style: .default) { (action) in
            
            if let description = descriptionTextField.text, let time = timeTextField.text, let sender = Auth.auth().currentUser?.email {
                let newTask = Task(sender: sender, description: description, time: time)
                self.task.append(newTask)
                            
//                self.db.collection("users").document(email).setData([
//                    "sender": sender,
//                    "time": time,
//                    "description": description,
//                    ], merge: true)
//                { (error) in
//                    if let e = error {
//                        print("There was an issue saving data to firestore, \(e) ")
//                        self.errorMessage.text = "Your data was not saved and sent, \(e.localizedDescription)"
//                    } else {
//                        print("Successfully saved data.")
//                    }
//                }
                
            }
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add time"
            timeTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add assignment details"
            descriptionTextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func assignButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func checkInButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
    }
    
    
    /* func loadTask() {
     
     } */
    
    /*func 
     
     */
    
}

//MARK: - Table View Data Source

extension MentorTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath) as! TaskCell
        cell.messageLabel?.text = task[indexPath.row].description
        cell.timeLabel?.text = task[indexPath.row].time
        cell.messageLabel?.numberOfLines = 0
        cell.timeLabel?.numberOfLines = 0
        return cell
    }
    
}


