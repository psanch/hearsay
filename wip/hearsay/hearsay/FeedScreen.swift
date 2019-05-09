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

var listening = false
var broadcasting = false

class FeedScreen: UITableViewController, AppFileManipulation, AppFileSystemMetaData, AppDirectoryNames, AppFileStatusChecking, MPCManagerDelegate {
    
    @IBOutlet var feedTableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBAction func newSay(_ sender: Any) {
        // function runs anytime someone clicks the new message button
        performSegue(withIdentifier: "newSay", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hearsayMessages = loadArrayHearsayMessagesFromFilesystem()
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
        
        appDelegate.mpcManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hearsayMessages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hearsayMessage = hearsayMessages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
        cell.setMessage(message: hearsayMessage)
        return cell
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
        
        hearsayMessages.sort(by: >)
        return hearsayMessages
    }
    
    /* Networking */
    
    @IBAction func refreshButton(_ sender: Any) {
        // listening functionality here
        if(listening == false){
            listening = true
            broadcasting = false
            appDelegate.mpcManager.browser.stopBrowsingForPeers()
            appDelegate.mpcManager.advertiser.startAdvertisingPeer()
            print("broadcasting: \(broadcasting)\tlistening: \(listening)")
        }
        else if(listening == true){
            
            listening = false
            broadcasting = true
            appDelegate.mpcManager.browser.startBrowsingForPeers()
            appDelegate.mpcManager.advertiser.stopAdvertisingPeer()
            print("broadcasting: \(broadcasting)\tlistening:\(listening)")
        }
    }
    /*
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        //Convert received Data into hearsayMessage
        let hm = hearsayMessage(raw: data)
        
        //Insert into feed, commit to filesystem
        insertHearsayMessageIntoSortedHearsayMessageArray(array: &hearsayMessages, message: hm)
        hm.writeToFile()
        
        //After downloaded file, disconnect from session.
        session.disconnect()
        
    }*/
    
    /* * * * * * MPCManagerDelegate Functionality * * * * * */
    
    func foundPeer() {
        //Invitation automatically sent
    }
    
    func lostPeer() {
        
    }
    
    func invitationWasReceived(fromPeer: String) { //Automatically accept invites to connect
        if listening == true{
            appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
            print("accepted invitation!")
        }
        else{
            appDelegate.mpcManager.invitationHandler(false, nil)
            print("declined invitation!")
        }
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        print("connected with peer! \(peerID)")
        if broadcasting == true{
            for hm in hearsayMessages {
                if(hm.broadcast == true){
                    appDelegate.mpcManager.sendData(hm: hm, toPeer: peerID)
                    print("\t\t sent message: \(hm_pass.sayIdentifier)")
                }
            }
            appDelegate.mpcManager.session.disconnect()
        }
    }
    
    func didReceiveData(fromPeer peerID: MCPeerID, rawData raw: Data) {
        let hm = hearsayMessage(raw: raw)
        hm.broadcast = false
        hm.sayFlag = false
        
        print("got data!! \(hm.sayIdentifier)")
        //Insert into feed; commit to filesystem
        insertHearsayMessageIntoSortedHearsayMessageArray(array: &hearsayMessages, message: hm)
        hm.writeToFile()
    }
    
    
    
}

func writeArrayHearsayMessagesToFilesystem(){
    for hm in hearsayMessages {
        hm.writeToFile()
    }
}
