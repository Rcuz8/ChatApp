//
//  MessageTableViewCell.swift
//  ChatApp
//
//  Created by Ryan Cocuzzo on 8/22/16.
//  Copyright © 2016 rcocuzzo8. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    
   
    @IBOutlet weak var messageTag: UILabel!
    
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
