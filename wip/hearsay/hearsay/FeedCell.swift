//
//  FeedCell.swift
//  hearsay
//
//  Created by Pedro Sanchez on 4/24/19.
//  Copyright © 2019 SeniorDesign. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var content: UILabel!
 
    func setMessage(message: hearsayMessage) {
        timestamp.text = message.timestamp
		username.text = message.username
		content.text = message.content
    }
}
