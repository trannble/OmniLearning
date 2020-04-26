//
//  MessageCellTableViewCell.swift
//  OmniLearning
//
//  Created by Tran Le on 4/26/20.
//  Copyright © 2020 TL Inc. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.layer.cornerRadius = label.frame.size.height / 5
        //corner radius will adapt with height of message
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
