//
//  ChatViewController.swift
//  OmniLearning
//
//  Created by Tran Le on 4/26/20.
//  Copyright © 2020 TL Inc. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    var userEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self

        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        
        loadMessage()
        tableView.separatorStyle = .none

    }
    
    func loadMessage() {
        db.collection("users").document(userEmail).collection("chat")
            .order(by: "dateCreated") //to order messages by time since 1970
            .addSnapshotListener { (querySnapShot, error) in
                
                self.messages = []
                
                if let e = error {
                    print ("There was an issue retrieving data from Firestore. \(e.localizedDescription)")
                } else {
                    if let snapshotDocuments = querySnapShot?.documents {
                        for doc in snapshotDocuments { //snapshotDocs is an array
                            let data = doc.data()
                            if let messageSender = data["sender"] as? String, let messageBody = data["body"] as? String {
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData() //we're updating the message on the main thread while the data fetching in the closure above is in the background
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
        }

    }

    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection("users").document(userEmail).collection("chat").addDocument(data: [
                "sender": messageSender,
                "body": messageBody,
                "dateCreated": Date().timeIntervalSince1970 //have to add this field so data can be ordered
            ]){ (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e.localizedDescription)")
                } else {
                    print("Successfully saved data")
                    DispatchQueue.main.async {
                        self.messageTextField.text = " "
                    }
                }
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        cell.label?.text = messages[indexPath.row].body
        
        //this is a message from the current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
        }
            
            //This is a message from another sender.
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
        }
        
        return cell
        
    }
}
