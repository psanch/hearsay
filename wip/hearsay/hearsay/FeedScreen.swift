//
//  FeedScreen.swift
//  hearsay
//
//  Created by Pedro Sanchez on 4/24/19.
//  Copyright © 2019 SeniorDesign. All rights reserved.
//

import UIKit
var hearsayMessages = [hearsayMessage]()
var passMessage: hearsayMessage!

class FeedScreen: UITableViewController, AppFileManipulation, AppFileSystemMetaData, AppDirectoryNames, AppFileStatusChecking {
    @IBOutlet var feedTableView: UITableView!

    @IBAction func newSay(_ sender: Any) {
        // function runs anytime someone clicks the new message button
        performSegue(withIdentifier: "newSay", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hearsayMessages = loadArrayHearsayMessagesFromFilesystem()
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passMessage = hearsayMessages[indexPath.row]
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
            hm = hearsayMessage(content: hc)
            hearsayMessages.append(hm)
        }
        
        if false {
            hearsayMessages.append(hearsayMessage(content: hearsayContent(author: "pedro", text: "hello my name is pedro i study compuer science and engineering and like to ride my skateboard. I sometimes bird around even though those are the most annoying invention. lets see how the app manages a content that goes past the height of the cell like if it gives you the dot dot dot or if it will overwrite the next cell or just do something unpredictable")))
            hearsayMessages.append(hearsayMessage(content: hearsayContent(author: "maddee", text: "goodbye")))
            hearsayMessages.append(hearsayMessage(content: hearsayContent(author: "eoin", text: "im a smart dude")))
            hearsayMessages.append(hearsayMessage(content: hearsayContent(author: "abby", text: "im going skydiving the day before mother's day i hope my mom doesnt get mad!!!!! jumping out of a plane scares me")))
        }
        
        hearsayMessages.sort(by: >)
        return hearsayMessages
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
}

func writeArrayHearsayMessagesToFilesystem(){
    for hm in hearsayMessages {
        hm.writeToFile()
    }
}
