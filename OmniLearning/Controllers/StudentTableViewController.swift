//
//  StudentTableViewController.swift
//  OmniLearning
//
//  Created by Tran Le on 4/22/20.
//  Copyright © 2020 TL Inc. All rights reserved.
//

import UIKit
import Firebase

class StudentTableViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var incentive: UILabel!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var errorMessage: UILabel!
    
    var email = "" //mentoremail
    var task: [Task] = []
    var studentEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDate.text = "🌟Let's get learning: \(getCurrentDate())"
        taskTableView.dataSource = self
        
        taskTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "prototypeCell")
        
        loadTasks()
        loadIncentive()
        taskTableView.separatorStyle = .none
        
    }
    
    func getCurrentDate() -> String {
        let currentDate = Date()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        let dateTimeString = formatter.string(from: currentDate)
        
        return dateTimeString
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToMessageFromStudent" {
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.userEmail = email
        }
    }
    
    @IBAction func askAndSubmitButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToMessageFromStudent", sender: self)
    }
    
    
    func loadIncentive() {
        db.collection("users").document(email).getDocument { (document, error) in
            if let document = document, document.exists {
                if let dataDescription = document.data() {
                    self.incentive.text = (dataDescription["incentive"] as! String)
                } else {
                    self.errorMessage.text = "Could not load today's reward"
                }
            }
        }
    }
        
        func loadTasks() {
            db.collection("users").document(email).collection("task")
                .order(by: "timeCreated")
                .addSnapshotListener { (querySnapshot, error) in
                    
                    self.task = []
                    
                    if let e = error {
                        print("There was an issue loading tasks from database, \(e)")
                        self.errorMessage.text = "\(e.localizedDescription)"
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
    
    extension StudentTableViewController: UITableViewDataSource {
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
