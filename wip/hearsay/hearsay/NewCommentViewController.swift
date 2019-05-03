//
//  NewCommentViewController.swift
//  hearsay
//
//  Created by Maddee Martin on 5/2/19.
//  Copyright © 2019 SeniorDesign. All rights reserved.
//

//PENDING:
//2) We need a tableView to show the comments; also need to overload its viewDidAppear() and include tableView.reloadData() to ensure that the new comment shows up.
//3) Haven't tested if the stuff I'm updating is "caught" (passed by reference) by the overarching hearsayMessage object. It's possible I'm updating a copy, so the changes won't be reflected. No idea-- can't test without tableView for comments.

import UIKit

class NewCommentViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var originalContent: UILabel!
    @IBOutlet weak var newComment: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalContent.text = hc_stack[0].text

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
            // Create new comment
            let hc_newComment = hearsayContent(author: myUsername, text: newComment.text)
            
            // Insert new comment into the parent's comments array. Always at index 0, since it's the newest comment.
            hc_stack[0].comments.insert(hc_newComment, at:0)
            
            //Commit new comment into filesystem
            hm_pass.writeToFile()
            
            navigationController?.popViewController(animated: true)
        }
    }
    
}
