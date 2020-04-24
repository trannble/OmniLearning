////
////  ScreenPicker.swift
////  OmniLearning
////
////  Created by Tran Le on 4/23/20.
////  Copyright © 2020 TL Inc. All rights reserved.
////
//
//import Foundation
//import Firebase
//
//struct ScreenPicker {
//
//    let db = Firestore.firestore()
//
//    func chooseScreen() {
//        db.collection("users").addSnapshotListener { (querrySnapshot, error) in
//
//            if let e = error {
//                print("Error getting userType: \(e.localizedDescription)")
//            } else {
//                if let snapshotDocuments = querrySnapshot?.documents {
//                    for document in snapshotDocuments {
//                        let data = document.data()
//                        if let savedUserType = data["userType"] as? String {
//                            if savedUserType == "Mentor" {
//                                self.performSegue(withIdentifier: "goToMentor", sender: self)
//                            } else if savedUserType == "Student" {
//                                self.performSegue(withIdentifier: "goToStudent", sender: self)
//                            } else {
//                                return
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//}
