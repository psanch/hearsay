

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

/* hearsayContent Testing Suite */

func hashTest(){
    var test = hearsayContent(author: "Pedro", text: "lol!")
    var test2 = hearsayContent(author: "Pedro", text: "lol!")
    
    print(test.hashValue == test2.hashValue)
    
    test.upvote()
    
    print(test.hashValue == test2.hashValue)
    
    test2.upvote()
    
    print(test.hashValue == test2.hashValue)

}

func compareTest(){
    var t1 = hearsayContent(author: "Pedro", text: "lol!")
    var t2 = hearsayContent(content: t1)
    
    print(t1 == t2, t1.hashValue == t2.hashValue, t1.hashValue, t2.hashValue)
    
    var t3 = hearsayContent(author: "Ben", text: "lmao")
    var t4 = hearsayContent(author: "Wes", text: "lmao")
    
    t1.addComment(content: t4)
    t2.addComment(content: t3)
    
    t1.addComment(content: t3)
    t2.addComment(content: t4)
    
    t1.sortComments()
    t2.sortComments()
    
    t1.upvote()
    t2.upvote()
    
    print(t1 == t2, t1.hashValue == t2.hashValue, t1.hashValue, t2.hashValue)
    
}

//compareTest()

func mergeCommentsTest(){
    var t1 = hearsayContent(author: "Pedro", text: "lol!")
    var t2 = hearsayContent(content: t1)
    
    var t3 = hearsayContent(author: "Ben", text: "lmao")
    var t4 = hearsayContent(author: "Alex", text: "lmao")
    var t5 = hearsayContent(author: "Wes", text: "lmao")
    var t6 = hearsayContent(author: "Andy", text: "lmao")
    
    t1.addComment(content: t4)
    t2.addComment(content: t3)
    t2.addComment(content: t5)
    t2.addComment(content: t6)
    
    var x = mergeContentTrees(l: t1.comments, r: t2.comments)
    for comment in x{
        print(comment.author)
    }
    print("***")
    x.sort()
    for comment in x{
        print(comment.author)
    }
    
}

//mergeCommentsTest()

func mergeContentsTest(){
    var t1 = hearsayContent(author: "Pedro", text: "lol!")
    var t2 = hearsayContent(content: t1)
    
    var t3 = hearsayContent(author: "Ben", text: "lmao")
    var t4 = hearsayContent(author: "Wes", text: "lmao")
    var t5 = hearsayContent(author: "Andy", text: "lmao")
    var t6 = hearsayContent(author: "Alex", text: "lmao")
    
    t1.addComment(content: t3)
    t2.addComment(content: t4)
    t2.addComment(content: t5)
    t2.addComment(content: t6)
    
    print("MERGING\n")
    
    var res = mergeHearsayContents(l: t1, r: t2)
    
    for comment in res.comments{
        print(comment.author)
    }
    
}
//mergeContentsTest()

func testMakeArrayUnique(){
    
    var a = [1, 1, 1, 2, 2, 2, 3, 4, 7]
    var i = 0
    
    while i < a.count-1{
        if(a[i] == a[i+1]){
            a[i] = a[i]
            a.remove(at: i+1)
            continue
        }
        i+=1
    }
    print(a)
}
//testMakeArrayUnique()

func testMergeTopDown(){
    
    var a = hearsayContent(author: "a", text: "a")
    var b1 = hearsayContent(author: "b1", text: "b1")
    var c1 = hearsayContent(author: "c1", text: "c1")
    var d = hearsayContent(author: "d", text: "d")
    var e = hearsayContent(author: "e", text: "e")
    var f = hearsayContent(author: "f", text: "f")
   
    var b2 = hearsayContent(content: b1)
    b2.text = "b2"
    
    var h = hearsayContent(author: "h", text: "h")
    var c3 = hearsayContent(content: c1)
    c3.text = "c3"
    
    
    c3.addComment(content: d)
    c3.addComment(content: e)
    
    b2.addComment(content: h)
    b2.addComment(content: c3)
    
    b1.addComment(content: c1)
    
    a.addComment(content: b1)
    a.addComment(content: b2)
    a.addComment(content: f)
    
    
    print("~~~~~~~~~~\nINITIAL STATE:\n")
    printHearsayRecursive(root: a, indent: 0)
    
    mergeHearsayRecursive(root: a)
    
    print("~~~~~~~~~~\nMERGED STATE:\n")
    printHearsayRecursive(root: a, indent: 0)
    
    /*
    print(hearsayContentsShouldBeMerged(l: c1, r: c3))
    
    print("***")
    printHearsayRecursive(root: a, indent: 0)
    print("***")
    
    mergeHearsayContentsList(children: &a.comments)
    b2.sortComments()
    
    
    print("***")
    printHearsayRecursive(root: a, indent: 0)
    print("***")
    mergeHearsayContentsList(children: &b2.comments)
    
    printHearsayRecursive(root: a, indent: 0)
    
    print(hearsayContentsShouldBeMerged(l: c1, r: c3))
    print("===")
    var x = mergeHearsayContents(l: c1, r: c3)
    printHearsayRecursive(root: x, indent: 0)
    */
}
//testMergeTopDown()


func testRoundtripContentToDataToString(){
   
    
    var a = hearsayContent(author: "a", text: "a")
    var b1 = hearsayContent(author: "b1", text: "b1")
    var c1 = hearsayContent(author: "c1", text: "c1")
    
    b1.addComment(content: c1)
    a.addComment(content: b1)
    
    printHearsayRecursive(root: a, indent: 0)
    
    var serialized = hearsayContentEncode(msg: a)
    
    var str = String(data: serialized, encoding:.utf8)!
    
    print("****")
    print(str)
    print("****")
    
    var raw = str.data(using: .utf8)!
    
    var returned = hearsayContent(data: raw)
    
    printHearsayRecursive(root: returned, indent: 0)
}

//testRoundtripContentToDataToString()

/* End hearsayContent Testing Suite */

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





