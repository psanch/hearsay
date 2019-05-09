//
//  hearsayMPC.swift
//  hearsay
//
//  Created by Pedro Sanchez on 5/8/19.
//  Copyright © 2019 SeniorDesign. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol MPCManagerDelegate {
    func foundPeer()
    
    func lostPeer()
    
    func invitationWasReceived(fromPeer: String)
    
    func connectedWithPeer(peerID: MCPeerID)
    
    func didReceiveData(fromPeer peerID: MCPeerID, rawData raw: Data)
}

class MPCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var delegate: MPCManagerDelegate?
    
    var session: MCSession!
    
    var peer: MCPeerID!
    
    var browser: MCNearbyServiceBrowser!
    
    var advertiser: MCNearbyServiceAdvertiser!
    
    var foundPeers = [MCPeerID]()
    
    var invitationHandler: ((Bool, MCSession?)->Void)!

    override init() {
        super.init()
        
        peer = MCPeerID(displayName: "hearsayUser")
        
        session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "hearsay-mpc")
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "hearsay-mpc")
        advertiser.delegate = self
    }
    
    /* * * * * * MCNearbyServiceBrowserDelegate * * * * * */
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        self.browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 20)
        print("found peer! \(peerID))")
        delegate?.foundPeer()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.lostPeer()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(error)
        listening = false
    }
    
    /* * * * * * MCNearbyServiceAdvertiserDelegate Functionality * * * * * */
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        self.invitationHandler = invitationHandler
        
        print("received invitation!")
        delegate?.invitationWasReceived(fromPeer: peerID.displayName)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error)
        broadcasting = false
    }
    
    /* * * * * * MCSessionDelegate Functionality * * * * * */

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
        delegate?.didReceiveData(fromPeer: peerID, rawData: data)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        
    }
    
    /* * * * * * Hearsay Messages Functionality * * * * * */

    func sendData(hm: hearsayMessage, toPeer peerID: MCPeerID){
        let hm_msg:Data! = hearsayMessageEncode(msg: hm_pass)
        
        do{
            try self.session.send(hm_msg!, toPeers: self.session.connectedPeers, with: .reliable)
        }
        catch{
            print("ERROR WHILE SENDING: \(error)")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
