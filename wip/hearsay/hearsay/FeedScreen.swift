//
//  FeedScreen.swift
//  hearsay
//
//  Created by Pedro Sanchez on 4/24/19.
//  Copyright © 2019 SeniorDesign. All rights reserved.
//

import UIKit
import MultipeerConnectivity

var hearsayMessages = [hearsayMessage]()

var hc_stack = [hearsayContent]() //Stack where you insert/pop at index 0. The element at index 0 is representative of the "deepest" comment accessed by the user after they start accessing detail view(s). !!! Need to figure out where to pop the top of the stack off (when the "back" button is pressed) !!!
var hm_pass: hearsayMessage! //Used to reference the top-level message (hm_pass.say == hc_stack[hc_stack.count-1]) for the purposes of committing to the filesystem if any changes are made to any of its children hearsayContent

var hosting:Bool!

class FeedScreen: UITableViewController, AppFileManipulation, AppFileSystemMetaData, AppDirectoryNames, AppFileStatusChecking, MCSessionDelegate, MCBrowserViewControllerDelegate {
    @IBOutlet var feedTableView: UITableView!

    @IBAction func newSay(_ sender: Any) {
        // function runs anytime someone clicks the new message button
        performSegue(withIdentifier: "newSay", sender: self)
    }
    
/*************************************/
    // voting buttons for cells
    @IBAction func upvoteBtn(_ sender: Any) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell // get the cell that was clicked on
        let indexPath = cell.upVote.tag // trying to get the tag for the buttons within each cell to be the index
        let content = hearsayMessages[indexPath].say // pick the right content
        cell.upvote(content: content) // call the appropriate function within feedcell.swift
    }
    
    @IBAction func downvoteBtn(_ sender: AnyObject) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
        let indexPath = cell.downVote.tag
        let content = hearsayMessages[indexPath].say
        cell.downvote(content: content)
    }
    /*************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        hearsayMessages = loadArrayHearsayMessagesFromFilesystem()
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
        
        /* Networking Setup: */
        peerID = MCPeerID(displayName: "hearsayUser")
        mcSession = MCSession(peer: peerID)
        mcSession.delegate = self
        
        hosting = false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Make sure that no previous comment trees accidentally kept in hc_stack
        hc_stack = []
        
        //Let the top of the stack be at index 0
        hc_stack.insert(hearsayMessages[indexPath.row].say, at: 0)
        
        //Preserve the top-level hearsayMessage
        hm_pass = hearsayMessages[indexPath.row]
        
        performSegue(withIdentifier: "detailView", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func loadArrayHearsayMessagesFromFilesystem() -> [hearsayMessage] {
        //Returns an array of hearsayMessage for each hearsayMessage stored as a file in the user's Documents directory
        var json_hc: String
        var data_hc: Data
        var hc: hearsayContent
        var hm: hearsayMessage
        
        let filenames = dirlist(directory: documentsDirectoryURL())
        var hearsayMessages = [hearsayMessage]()
        
        for filename in filenames {
            if(filename == ".DS_Store"){
                continue
            }
            json_hc = readFile(at: .Documents, withName: filename)
            data_hc = json_hc.data(using: .utf8)!
            hc = hearsayContent(data: data_hc)
            hm = hearsayMessage(content: hc, isSay: true)
            hearsayMessages.append(hm)
        }
        
        if false {
            hearsayMessages.append(hearsayMessage(content: hearsayContent(author: "pedro", text: "hello my name is pedro i study compuer science and engineering and like to ride my skateboard. I sometimes bird around even though those are the most annoying invention. lets see how the app manages a content that goes past the height of the cell like if it gives you the dot dot dot or if it will overwrite the next cell or just do something unpredictable"), isSay: true))
            hearsayMessages.append(hearsayMessage(content: hearsayContent(author: "maddee", text: "goodbye"), isSay: true))
            hearsayMessages.append(hearsayMessage(content: hearsayContent(author: "eoin", text: "im a smart dude"), isSay: true))
            hearsayMessages.append(hearsayMessage(content: hearsayContent(author: "abby", text: "im going skydiving the day before mother's day i hope my mom doesnt get mad!!!!! jumping out of a plane scares me"), isSay: true))
        }
        
        hearsayMessages.sort(by: >)
        return hearsayMessages
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hearsayMessages.count
    }

/*************************************/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hearsayMessage = hearsayMessages[indexPath.row] // was here before
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell // was here before
        cell.upVote.addTarget(self, action: #selector(upvoteBtn), for: .touchUpInside) // i found an article that said that you should set a target for the @ibaction button funciton (above) in order to execute but since we need separate functions for each cell i make a call in the button functions (above) to the feedcell.swift functions
        cell.downVote.addTarget(self, action: #selector(downvoteBtn), for: .touchUpInside)
        cell.setMessage(message: hearsayMessage, index: indexPath.row) // was here before
        return cell // was here before
    }
/*************************************/

    /* Networking */
    
    var peerID:MCPeerID!
    var mcSession:MCSession!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!
    
    
    
    @IBAction func refreshButton(_ sender: Any) {
        // listening functionality here
        
        let connectActionSheet = UIAlertController(title: "Listening...", message: "Hearsay users must be in range and broadcasting in order to receive their messages. Pick the message(s) you would like to download.", preferredStyle: .actionSheet)
        
        connectActionSheet.addAction(UIAlertAction(title: "Listen for messages", style: .default, handler: {
            (action: UIAlertAction) in
            
            let mcBrowser = MCBrowserViewController(serviceType: "hearsay", session: self.mcSession)
            mcBrowser.delegate = self
            
            //shows the MPCF browser with available connections
            self.present(mcBrowser, animated: true, completion: nil)
            
        }))
        
        connectActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(connectActionSheet, animated: true, completion: nil)
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        //Convert received Data into hearsayMessage
        let hm = hearsayMessage(raw: data)
        
        //Insert into feed, commit to filesystem
        insertHearsayMessageIntoSortedHearsayMessageArray(array: &hearsayMessages, message: hm)
        hm.writeToFile()
        
        //After downloaded file, disconnect from session.
        session.disconnect()
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

func writeArrayHearsayMessagesToFilesystem(){
    for hm in hearsayMessages {
        hm.writeToFile()
    }
}
