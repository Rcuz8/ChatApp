//
//  ChatTableViewCell.swift
//  ChatApp
//
//  Created by Ryan Cocuzzo on 8/18/16.
//  Copyright © 2016 rcocuzzo8. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
