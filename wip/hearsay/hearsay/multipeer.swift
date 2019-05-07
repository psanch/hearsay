//
//  multipeer.swift
//  hearsay
//
//  Created by Pedro Sanchez on 5/5/19.
//  Copyright © 2019 SeniorDesign. All rights reserved.
//

import Foundation
import MultipeerConnectivity

var connectedPeers = [MCPeerID]()

protocol MPCManagerDelegate {
    func foundPeer()
    
    func lostPeer()
    
    func invitationWasReceived(fromPeer: String)
    
    func connectedWithPeer(peerID: MCPeerID)
}

class MPCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var delegate: MPCManagerDelegate?
    
    var session: MCSession!
    var peer: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    
    
    //var invitationHandler: ((Bool, MCSession?)->Void)/*!*/
    
    var isAdvertising: Bool!

    override init() {
        super.init()
        
        peer = MCPeerID(displayName: "UIDevice.currentDevice().name")
        
        session = MCSession(peer: peer)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "hearsay")
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "hearsay")
        advertiser.delegate = self
        
        self.isAdvertising = false
    }
    
    /* Interface */
    
    func connectedWithPeer(peerID: MCPeerID) {
        connectedPeers.append(peerID)
        var hm_msg:Data!
        
        for hm in hearsayMessages {
            hm_msg = hearsayMessageEncode(msg: hm)
            
            do{
                try appDelegate.mpcManager.session.send(hm_msg!, toPeers: session.connectedPeers, with: .reliable)
                
            }
            catch{
                print("Error sending message :(")
            }
        }
        
        
    }
    
    /* Browser */
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        appDelegate.mpcManager.browser.invitePeer(peerID, to: appDelegate.mpcManager.session, withContext: nil, timeout: 20)
        
        delegate?.foundPeer()

    }
    
    func browser(_ browser: MCNearbyServiceBrowser/*!*/, lostPeer peerID: MCPeerID/*!*/) {
        delegate?.lostPeer()
    }
    
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        print(error.localizedDescription)
    }
    
    
    
    /* Advertiser */
    
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        if checkIfSeenPeerBefore(target: peerID) == true {
            invitationHandler(false, nil)//nil)
        }
        else{
            invitationHandler(true, appDelegate.mpcManager.session)
        }
        
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        print(error.localizedDescription)
    }
    
    
    
    /* Session */
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state{
            case MCSessionState.connected:
                print("Connected to session: \(session)")
                delegate?.connectedWithPeer(peerID: peerID)
            
            case MCSessionState.connecting:
                print("Connecting to session: \(session)")
            
            default:
                print("Did not connect to session: \(session)")
        }
        
        
        
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
    
    
}

func checkIfSeenPeerBefore(target:MCPeerID) -> Bool {
    for p in connectedPeers {
        if target == p{
            return true
        }
    }
    return false
}
