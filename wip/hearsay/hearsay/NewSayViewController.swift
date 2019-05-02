//
//  NewSayViewController.swift
//  hearsay
//
//  Created by Maddee Martin on 4/30/19.
//  Copyright © 2019 SeniorDesign. All rights reserved.
//

import UIKit

class NewSayViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var postingAs: UILabel!
    @IBOutlet weak var sayContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postingAs.text = "Posting as: " + myUsername
        
        sayContent.text = "What do you want to say?"
        sayContent.textColor = UIColor.lightGray
        sayContent.delegate = self
    }
    
    func textViewDidBeginEditing(_ sayContent: UITextView) {
        if sayContent.textColor == UIColor.lightGray {
            sayContent.text = nil
            sayContent.textColor = UIColor.black
        }
    }
    
    @IBAction func saySomethingButton(_ sender: Any) {
        if sayContent.textColor != UIColor.lightGray || sayContent.text != nil {
            // create hearsayContent here
            let hc = hearsayContent(author: myUsername, text: sayContent.text)
            let hm = hearsayMessage(content: hc)
            
            insertHearsayMessageIntoSortedHearsayMessageArray(array: &hearsayMessages, message: hm)
            hm.writeToFile()
            
            //performSegue(withIdentifier: <#T##String#>, sender: self)
            
        }
    }
    
}
