//
//  Message.swift
//  hearsay
//
//  Created by Pedro Sanchez on 4/24/19.
//  Copyright © 2019 SeniorDesign. All rights reserved.
//

import Foundation

class Message {
    var timestamp: String
    var username: String
    var content: String
    
    init(timestamp: String, username: String, content: String) {
        self.timestamp = timestamp
        self.username = username
        self.content = content
    }
}
