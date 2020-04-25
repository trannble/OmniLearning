//
//  TaskCell.swift
//  OmniLearning
//
//  Created by Tran Le on 4/25/20.
//  Copyright © 2020 TL Inc. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
