//
//  NewCommentViewController.swift
//  hearsay
//
//  Created by Maddee Martin on 5/2/19.
//  Copyright © 2019 SeniorDesign. All rights reserved.
//

import UIKit

class NewCommentViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var originalContent: UILabel!
    @IBOutlet weak var newComment: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalContent.text = passMessage.content

        // sets placeholder
        newComment.text = "Add a comment"
        newComment.textColor = UIColor.lightGray
        newComment.delegate = self
    }
    
    func textViewDidBeginEditing(_ newComment: UITextView) {
        // removes placeholder text
        if newComment.textColor == UIColor.lightGray {
            newComment.text = nil
            newComment.textColor = UIColor.black
        }
    }
    
    @IBAction func newCommentButton(_ sender: Any) {
        if newComment.textColor != UIColor.lightGray || newComment.text != nil {
            // create new comment here
            
            navigationController?.popViewController(animated: true)
        }
    }
    
}
