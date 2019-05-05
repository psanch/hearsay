//
//  CommentCell.swift
//  hearsay
//
//  Created by Maddee Martin on 5/5/19.
//  Copyright © 2019 SeniorDesign. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var commentTimestamp: UILabel!
    @IBOutlet weak var commentUsername: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    
    func setComment(comment: hearsayContent) {
        commentTimestamp.text = comment.getTimestamp()
        commentUsername.text = comment.author
        commentContent.text = comment.text
    }
}
