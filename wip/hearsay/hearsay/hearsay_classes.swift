

/* hearsayContent Class definition */

class hearsayContent: Encodable, Decodable {

    var timestamp: Int
    
    var author: String
    var text: String
    
    var comments: [hearsayContent]
    
    var upvotes: Int
    var downvotes: Int
    
    init(author: String, text: String){
        self.timestamp = 0
        
        self.author = author
        self.text = text
        
        self.comments = [hearsayContent]()
        
        self.upvotes = 0
        self.downvotes = 0
        
    }
    
    init(content: hearsayContent){
        self.timestamp = content.timestamp
        self.author = content.author
        self.text = content.text
        self.comments = content.comments
        self.upvotes = content.upvotes
        self.downvotes = content.downvotes
    }
    
    
    init(timestamp: Int, author: String, text: String, comments: [hearsayContent], upvotes: Int, downvotes: Int){
        self.timestamp = timestamp
        self.author = author
        self.text = text
        self.comments = comments
        self.upvotes = upvotes
        self.downvotes = downvotes
    }
    
    init(data: Data){
        let jsonDecoder = JSONDecoder()
        let msg = try! jsonDecoder.decode(hearsayContent.self, from: data)
        
        self.timestamp = msg.timestamp
        self.author = msg.author
        self.text = msg.text
        self.comments = msg.comments
        self.upvotes = msg.upvotes
        self.downvotes = msg.downvotes
    }
    
    func upvote(){
        self.upvotes += 1
    }
    
    func downvote(){
        self.downvotes += 1
    }
    
    func getVotes() -> Int {
        return self.upvotes - self.downvotes
    }
    
    func addComment(content: hearsayContent){
        self.comments.append(content)
    }
    
    func sortComments(){
        self.comments.sort()
    }
}

/* End hearsayContent Class Definition */

/* hearsayContent Extensions: Encodable(encode()), Equatable(==), Hashable(.hashValue), Comparable(<) */

func hearsayContentEncode(msg: hearsayContent) -> Data {
    let jsonEncoder = JSONEncoder()
    let jsonData = try! jsonEncoder.encode(msg)
    return jsonData
    
    //Example of how to encode Data -> String
    //let jsonString = String(data: jsonData, encoding: .utf8)
}

extension hearsayContent: Equatable {
    static func == (left: hearsayContent, right: hearsayContent) -> Bool {
        return (
                (left.hashValue == right.hashValue) &&
                (left.timestamp == right.timestamp) && //timestamps will differ very precisely (seconds matter; a line of code matters)
                (left.author == right.author) &&
                (left.text == right.text) && //strings have built-in equivalence operator
                (left.comments == right.comments) && //recursive definition of equivalence operator okay
                (left.upvotes == right.upvotes) &&
                (left.downvotes == right.downvotes)
        )
    }
}

extension hearsayContent: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(author)
        hasher.combine(text)
        hasher.combine(timestamp)
        hasher.combine(upvotes)
        hasher.combine(downvotes)
        hasher.combine(comments)
    }
    
    var hashValue: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
}

extension hearsayContent: Comparable{
    static func < (l: hearsayContent, r: hearsayContent) -> Bool {
        if(l.author != r.author){
            return l.author < r.author
        }
        else{
            return l.text < r.text
        }
    }
}

/* End hearsayContent Extensions */

/* hearsayContent Merging Functions */

func mergeContentTrees(l: [hearsayContent], r: [hearsayContent]) -> [hearsayContent]{
    let set1:Set<hearsayContent> = Set(l)
    let set2:Set<hearsayContent> = Set(r)
    return Array(set1.union(set2))
}

func hearsayContentsShouldBeMerged(l: hearsayContent, r: hearsayContent) -> Bool {
    if (
        l.timestamp == r.timestamp &&
        l.author == r.author &&
        true //l.text == r.text
        ){
        return true
    }
    return false
}

func mergeHearsayContents(l: hearsayContent, r: hearsayContent) -> hearsayContent {
    if l == r {
        return l
    }
    var newUpvotes: Int
    var newDownvotes: Int
    var newComments: [hearsayContent]
    
    //If number of votes different, take sum of both
    if(l.upvotes != r.upvotes){
        newUpvotes = l.upvotes + r.upvotes
    }
    else{
        newUpvotes = l.upvotes
    }
    
    if(l.downvotes != r.downvotes){
        newDownvotes = l.downvotes + r.downvotes
    }
    else{
        newDownvotes = l.downvotes
    }
    
    if(l.comments != r.comments){
        newComments = mergeContentTrees(l: l.comments, r: r.comments)
    }
    else{
        newComments = l.comments
    }
    
    var newHearsayContent = hearsayContent(timestamp: l.timestamp, author: l.author, text: l.text, comments: newComments, upvotes: newUpvotes, downvotes: newDownvotes)
    
    newHearsayContent.comments.sort()
    
    return newHearsayContent
}

func mergeHearsayContentsList(children: inout [hearsayContent]){
    var i = 0
    children.sort()
    while(i < children.count-1){
        if(hearsayContentsShouldBeMerged(l: children[i], r: children[i+1])){
            children[i] = mergeHearsayContents(l: children[i], r: children[i+1])
            children.remove(at: i+1)
            continue
        }
        i+=1
    }
}

func mergeHearsayRecursive(root: hearsayContent){
    mergeHearsayContentsList(children: &root.comments)
    for child in root.comments{
        mergeHearsayRecursive(root: child)
    }
}

/* End hearsayContent Merging Functions */

/* hearsayContent Print Helper Functions */

func printHearsayContent(msg: hearsayContent, indent: Int){
    var indentString = ""
    for _ in 0..<indent{
        indentString += "\t"
    }
    print(indentString + "HashValue: \(msg.hashValue)")
    print(indentString + "Author: \(msg.author)")
    print(indentString + "Timestamp: \(msg.timestamp)")
    print(indentString + "Text: \(msg.text)")
    print(indentString + "Upvotes: \(msg.upvotes)")
    print(indentString + "Downvotes: \(msg.downvotes)")
}

func printHearsayRecursive(root: hearsayContent, indent: Int){
    var indentString = ""
    for _ in 0..<indent{
        indentString += "\t"
    }
    print(indentString + "=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~")
    printHearsayContent(msg: root, indent: indent)
    for child in root.comments{
        printHearsayRecursive(root: child, indent: indent+1)
    }
    print(indentString + "=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~")
}

/* End hearsayContent Print Helper Functions */

/* hearsayMessage Class Definition */

class hearsayMessage: Encodable, Decodable, AppFileManipulation, AppFileStatusChecking, AppFileSystemMetaData {
    var sayIdentifier: String
    var say: hearsayContent
    
    init(content: hearsayContent){
        self.say = content
        self.sayIdentifier = content.author + content.text
    }
    
    init(filename: String){ //filename must be a file containing a JSON-encoded hearsayMessage in Documents/
        let hearsayContentString = readFile(at: .Documents, withName: filename)
        let raw = hearsayContentString.data(using: .utf8)!
        self.say = hearsayContent(data: raw)
        self.sayIdentifier = self.say.author + self.say.text
    }
    
    func writeToFile(){
        
        var messageString: String
        do{
            writeFile(containing: messageString, to: .Documents, withName: self.sayIdentifier)
        }
        catch{
            print("Unable to store message: \(self.sayIdentifier)")
        }
       messageString = String(data: hearsayContentEncode(msg: self.say), encoding:.utf8)! //self.say gets sent to a serialized Data, which initalizes an equivalent String representation.
        
    }
    
    
}

/* end hearsayMessage Class Definition */





