//
//  CellDetailViewController.swift
//  hearsay
//
//  Created by Maddee Martin on 4/30/19.
//  Copyright © 2019 SeniorDesign. All rights reserved.
//

import UIKit


class CellDetailViewController: UIViewController {
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var comments: UILabel!
    
    var passedMessage: hearsayMessage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timestamp.text = passMessage.timestamp
        username.text = passMessage.username
        content.text = passMessage.content
        comments.text = String(passMessage.say.comments.count) + " Comments"
    }
}
