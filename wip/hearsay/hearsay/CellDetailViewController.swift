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
        timestamp.text = hc_stack[0].getTimestamp()
        username.text = hc_stack[0].author
        content.text = hc_stack[0].text
        comments.text = String(hc_stack[0].comments.count) + " Comments"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Refresh the comment count
        comments.text = String(hc_stack[0].comments.count) + " Comments"
    }
    
    @IBAction func newComment(_ sender: Any) {
        // function runs anytime someone clicks the reply button
        performSegue(withIdentifier: "newComment", sender: self)
    }
    
}
