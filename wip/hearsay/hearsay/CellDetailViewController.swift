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
    
    var passedMessage: hearsayMessage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timestamp.text = passMessage.timestamp
        username.text = passMessage.username
        content.text = passMessage.content
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
