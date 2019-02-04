import Cocoa

struct messageStruct {
    var messageID: String
    var timestamp: Date
    
    var author: String
    var contents: String
    
    var comments: [String]
    var votes: Int
    
    init(author: String, contents: String){
        self.timestamp = Date()
        
        self.author = author
        self.contents = contents
        
        self.comments = [String]()
        self.votes = 0
        
        self.messageID = "abc123" //should be the hash value of all the above
    }
    
    mutating func addComment(comment: String){
        self.comments.append(comment)
    }
    
    mutating func upvote(){
        self.votes += 1
    }
    
    mutating func downvote(){
        self.votes -= 1
    }
    
    
}

func printMsg(msg: messageStruct){
    print("MessageID: \(msg.messageID)\nTimestamp: \(msg.timestamp)\nAuthor: \(msg.author)\nContents: \(msg.contents)\nComments: \(String(describing: msg.comments))\nVotes: \(msg.votes)\n")
}


//Overloading the equality operator
//Allows messageStruct1 == messageStruct2
extension messageStruct: Equatable {
    static func == (left: messageStruct, right: messageStruct) -> Bool {
        return (
            (left.messageID == right.messageID) &&
            (left.timestamp == right.timestamp) && //timestamps will differ very precisely (seconds matter)
            (left.author == right.author) &&
            (left.contents == right.contents) && //strings have built-in equivalence operator
            (left.comments == right.comments) &&
            (left.votes == right.votes)
        )
    }
}

var m1 = messageStruct(author: "Pedro", contents: "1")
printMsg(msg: m1)

/* Working on serializing and unserializing data.
 //Currently, getting the data size is the problem. Doesn't expand when a comment is added.

var data = NSData(bytes: &m1, length: MemoryLayout<messageStruct>.size )

print("data: \(data)")
printMsg(msg: m1)

m1.addComment(comment: "Shit!")

var data2 = NSData(bytes: &m1, length: MemoryLayout<messageStruct>.size )

print("data: \(data2)")
printMsg(msg: m1)
 
 */

