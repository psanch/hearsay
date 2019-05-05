//
//  InitialViewController.swift
//  hearsay
//
//  Created by Maddee Martin on 5/1/19.
//  Copyright © 2019 SeniorDesign. All rights reserved.
//

import UIKit
var myUsername: String = ""

class InitialViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var myName: UITextField!
    
    @IBAction func setUsername(_ sender: Any) {
        if myName.text != "" {
            myUsername = myName.text!
            performSegue(withIdentifier: "setUsername", sender: self)
        }
        else {
            let alert = UIAlertController(title: "You need to input a username to continue", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func returnButtonPressed(_ sender: Any) {
        setUsername(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if myUsername already has a name
        // perform segue to feed
    }
}
