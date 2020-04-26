//
//  MentorTableViewController.swift
//  OmniLearning
//
//  Created by Tran Le on 4/22/20.
//  Copyright © 2020 TL Inc. All rights reserved.
//

import UIKit
import Firebase
import SwipeCellKit

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
        
        loadTasks()
        taskTableView.separatorStyle = .none
        
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
                                
                self.db.collection("users").document(self.email).collection("task").document("task\(self.task.count)").setData([
                    "sender": sender,
                    "time": time,
                    "description": description,
                    "timeCreated":  Date().timeIntervalSince1970
                ]){ (error) in
                    if let e = error {
                        print("There was an issue saving data to firestore, \(e) ")
                        self.errorMessage.text = "Your data was not saved and sent, \(e.localizedDescription)"
                    } else {
                        print("Successfully saved data.")
                    }
                }
            }
                        
            self.taskTableView.reloadData()
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
        do {
            try Auth.auth().signOut()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            errorMessage.text = signOutError.localizedDescription
        }
    }
    
    @IBAction func assignButtonPressed(_ sender: UIButton) {
        
        if let incentive = incentive.text {
            errorMessage.textColor = UIColor.black
            errorMessage.numberOfLines = 0
            errorMessage.text = "Successfully assigned, check back for progress!"
            db.collection("users").document(email).setData(["incentive": incentive], merge: true)
            { (error) in
                if let e = error {
                    print("There was an issue saving new assignment to respective mentor account \(e.localizedDescription)")
                    self.errorMessage.text = e.localizedDescription
                }
            }
        }
    }
    
    @IBAction func checkInButtonPressed(_ sender: UIButton) {
        //goes to FlashChat, can send images
        //if don't have time to code this part -> just link to facebook messenger
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
               
        var taskNumber = 1

        for _ in 1...task.count {
                        
            if taskNumber <= task.count {
                
                //delete in firestore
                db.collection("users").document(email).collection("task").document("task\(taskNumber)").delete() { error in
                    
                    if let e = error {
                        print("Error removing document: \(e)")
                        self.errorMessage.text = e.localizedDescription
                    } else {
                        self.errorMessage.textColor = UIColor.black
                        self.errorMessage.text = "Ready for a new day of learning!"
                    }
                }
                
                taskNumber += 1
        
            } else {
                return
            }
        }
        
        task = []
        
        DispatchQueue.main.async {
            self.taskTableView.reloadData()
        }
    }
    
    func loadTasks() {
        
        db.collection("users").document(email).collection("task")
            .order(by: "timeCreated")
            .addSnapshotListener { (querySnapshot, error) in
                
                self.task = []
                
                if let e = error {
                    print("There was an issue loading tasks from database, \(e)")
                    return
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let description = data["description"] as? String, let time = data["time"] as? String, let sender = data["sender"] as? String {
                                let newTask = Task(sender: sender, description: description, time: time)
                                self.task.append(newTask)
                                
                                DispatchQueue.main.async {
                                    self.taskTableView.reloadData()
                                }
                            }
                        }
                    }
                }
        }
    }
    
    
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


