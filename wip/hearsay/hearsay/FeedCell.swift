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
	
	func setMessage(message: hearsayMessage, index: Int) {
        timestamp.text = message.timestamp
		username.text = message.username
		content.text = message.content
		voteCount.text = String(message.say.getVotes())
		upVote.tag = index // this apparently doesnt do the right thing
    }
	
	func upvote(content: hearsayContent) {
		print(content.author) // this and below keep printing the info from cell 0 which is the index so this is the biggest problem
		print(upVote.tag)
		//content.upvote()
		//voteCount.text = String(content.getVotes())
		//print(content.getVotes())
		//print("change color here")
	}
	
	func downvote(content: hearsayContent) {
		// hasnt voted yet
		/*if downVote.titleColor(for: .normal) == UIColor.lightGray {
		
			// if they had upvoted already
			if upVote.titleColor(for: .normal) == UIColor.orange {
				content.upvotes -= 1
				upVote.setTitleColor(UIColor.lightGray, for: .normal)
			}
			
			content.downvote()
			voteCount.text = String(content.getVotes())
			downVote.setTitleColor(UIColor.orange, for: .normal)
		}*/
		print("downvote")
	}
}
