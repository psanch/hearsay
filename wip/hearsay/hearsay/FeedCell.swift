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
	@IBOutlet weak var voteCount: UILabel!
	@IBOutlet weak var upVote: UIButton!
	@IBOutlet weak var downVote: UIButton!
	
	func setMessage(message: hearsayMessage) {
        timestamp.text = message.timestamp
		username.text = message.username
		content.text = message.content
		voteCount.text = String(message.say.getVotes())
    }
	
	func upvote(content: hearsayContent) {
		// hasnt voted yet
		if upVote.titleColor(for: .normal) == UIColor.lightGray {
			
			// if they had downvoted already
			if downVote.titleColor(for: .normal) == UIColor.orange {
				content.downvotes -= 1
				downVote.setTitleColor(UIColor.lightGray, for: .normal)
			}
			
			content.upvote()
			voteCount.text = String(content.getVotes())
			upVote.setTitleColor(UIColor.orange, for: .normal)
		}
	}
	
	func downvote(content: hearsayContent) {
		// hasnt voted yet
		if downVote.titleColor(for: .normal) == UIColor.lightGray {
			
			// if they had upvoted already
			if upVote.titleColor(for: .normal) == UIColor.orange {
				content.upvotes -= 1
				upVote.setTitleColor(UIColor.lightGray, for: .normal)
			}
			
			content.downvote()
			voteCount.text = String(content.getVotes())
			downVote.setTitleColor(UIColor.orange, for: .normal)
		}
	}
}
