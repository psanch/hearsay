import Cocoa

struct messageStruct: Encodable, Decodable {
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
    
    init(data: Data){
        let jsonDecoder = JSONDecoder()
        let msg = try! jsonDecoder.decode(messageStruct.self, from: data)
        
        self.messageID = msg.messageID
        self.timestamp = msg.timestamp
        
        self.author = msg.author
        self.contents = msg.contents
        
        self.comments = msg.comments
        self.votes = msg.votes
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

//Should possibly re-factor this to be a member function?
func encode(msg: messageStruct) -> Data{
    let jsonEncoder = JSONEncoder()
    let jsonData = try! jsonEncoder.encode(msg)
    return jsonData
    
    //Example of how to encode Data -> String
    //let jsonString = String(data: jsonData, encoding: .utf8)
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

func printMsg(msg: messageStruct){
    print("MessageID: \(msg.messageID)\nTimestamp: \(msg.timestamp)\nAuthor: \(msg.author)\nContents: \(msg.contents)\nComments: \(String(describing: msg.comments))\nVotes: \(msg.votes)\n")
}

//Overloading the equality operator
//Allows messageStruct1 == messageStruct2
extension messageStruct: Equatable {
    static func == (left: messageStruct, right: messageStruct) -> Bool {
        return (
            (left.messageID == right.messageID) &&
                (left.timestamp == right.timestamp) && //timestamps will differ very precisely (seconds matter; a line of code matters)
            (left.author == right.author) &&
            (left.contents == right.contents) && //strings have built-in equivalence operator
            (left.comments == right.comments) && //array of <Type_defaults> have built-in equivalence operator
            (left.votes == right.votes)
        )
    }
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

/* Example that shows how to:
    * Instantiate messageStruct with Author and Contents
    * Add a comment
    * Vote (up and down)
    * Encode messageStruct to JSON (Data)
    * Initialize a new messageStruct from a Data
*/

func example1(){
    
    var m1 = messageStruct(author: "Username", contents: "Contents")
    m1.addComment(comment: "Add a comment")
    m1.addComment(comment: "And another")
    m1.upvote()
    m1.upvote()
    m1.downvote()
    
    let m1json = encode(msg: m1)
    
    //print(Data) only gives number of bytes
    print(m1json)
    
    //can instantiate a string like this for a pretty-print:
    //let jsonString = String(data: m1json, encoding: .utf8)
    //print(jsonString)
    
    let m1d = messageStruct(data: m1json)
    
    if(m1 == m1d){
        print("Message successfully en/decoded!")
    }
}

/* Testing to see if we can send messageStruct -> Data -> String and back */

func example2(){
    var m = messageStruct(author: "Username", contents: "Contents")
    m.addComment(comment: "Add a comment")
    m.addComment(comment: "And another")
    m.upvote()
    
    //struct -> Data
    let jsondata = encode(msg: m)
    
    // Data -> String
    let jsonString = String(data: jsondata, encoding: .utf8)!
    
    print(jsonString)
    
    var arrayJsonString = [String]()
    arrayJsonString.append(jsonString)
    
    
    //String -> Data
    let dataFromString = jsonString.data(using: .utf8)!
   
    //Data -> Struct
    let result = messageStruct(data: dataFromString)
    
    print(result.votes)
    
    //let jsonDecoder = JSONDecoder()
    //let jsondata_returned = try jsonDecoder.decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: <#T##Data#>)
    
    
    
}

example2()

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

//Most work done here was on the basis of this tutorial
//https://www.raywenderlich.com/382-encoding-decoding-and-serialization-in-swift-4

