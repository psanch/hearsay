//
//  CellDetailViewController.swift
//  hearsay
//
//  Created by Maddee Martin on 4/30/19.
//  Copyright © 2019 SeniorDesign. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class CellDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var upBtn: UILabel!
    @IBOutlet weak var dnBtn: UILabel!
    
    @IBOutlet weak var commentsTableView: UITableView!
    var passedMessage: hearsayMessage!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* UI Setup: */
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        timestamp.text = hc_stack[0].getTimestamp()
        username.text = hc_stack[0].author
        content.text = hc_stack[0].text
        comments.text = String(hc_stack[0].comments.count) + " Comments"
        voteCount.text = String(hc_stack[0].getVotes())
        let upvote = UITapGestureRecognizer(target: self, action: #selector(CellDetailViewController.upVote))
        upBtn.addGestureRecognizer(upvote)
        upBtn.textColor = UIColor.lightGray
        let dnvote = UITapGestureRecognizer(target: self, action: #selector(CellDetailViewController.dnVote))
        dnBtn.addGestureRecognizer(dnvote)
        dnBtn.textColor = UIColor.lightGray

        /* Networking Setup: */
        //appDelegate.mpcManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Refresh the comment count
        comments.text = String(hc_stack[0].comments.count) + " Comments"
        commentsTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //maybe pop the top of hc_stack here?
    }
    
    @IBAction func newComment(_ sender: Any) {
        // function runs anytime someone clicks the reply button
        performSegue(withIdentifier: "newComment", sender: self)
    }
    
    @objc func upVote() {
        // hasnt up voted yet
        if upBtn.textColor == UIColor.lightGray {
            
            // if they had down voted already
            if dnBtn.textColor == UIColor.orange {
                hc_stack[0].downvotes -= 1
                dnBtn.textColor = UIColor.lightGray
            }
            
            hc_stack[0].upvote()
            voteCount.text = String(hc_stack[0].getVotes())
            upBtn.textColor = UIColor.orange
        }
        
        //had already upvoted (should take it away)
        else if upBtn.textColor == UIColor.orange {
            hc_stack[0].upvotes -= 1
            voteCount.text = String(hc_stack[0].getVotes())
            upBtn.textColor = UIColor.lightGray
        }
    }
 
    @objc func dnVote() {
        // hasnt down voted yet
        if dnBtn.textColor == UIColor.lightGray {
            
            // if they had up voted already
            if upBtn.textColor == UIColor.orange {
                hc_stack[0].upvotes -= 1
                upBtn.textColor = UIColor.lightGray
            }
            
            hc_stack[0].downvote()
            voteCount.text = String(hc_stack[0].getVotes())
            dnBtn.textColor = UIColor.orange
        }
        
        // had already downvoted (should take it away)
        else if dnBtn.textColor == UIColor.orange {
            hc_stack[0].downvotes -= 1
            voteCount.text = String(hc_stack[0].getVotes())
            dnBtn.textColor = UIColor.lightGray
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hc_stack[0].comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = hc_stack[0].comments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        cell.setComment(comment: comment)
        return cell
    }

    /* I think this is what is needed to recursively be able to navigate comments. Two issues:
     1) There is no segue in the storyboard and I'm not sure how to fix it. The error that was thrown is: """ "*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Receiver (<hearsay.CellDetailViewController: 0x7fb46dd46ed0>) has no segue with identifier 'detailView''""
     2) When the back button is pressed, the element at hc_stack[0] needs to be popped. Not sure how/where to do this. This is so that when I go back, the previous comment I was previously looking at gets loaded into the detailView. Maybe we have to override the popViewController() func and include a hc_stack.remove()?
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Let the top of the stack be at index 0
        hc_stack.insert(hc_stack[0].comments[indexPath.row], at: 0)
        
        performSegue(withIdentifier: "detailView", sender: self)
    }*/
    
    /* Begin Networking */
    
    @IBAction func shareMessageButton(_ sender: Any) {
        //Kill any previous messages being broadcasted/listened for.
        
        hm_pass.broadcast = !hm_pass.broadcast
        print("\t\(hm_pass.sayIdentifier).broadcast: \(hm_pass.broadcast)")
    }

    
}
