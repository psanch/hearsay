//
//  hearsay_classes_tests.swift
//  hearsay
//
//  Created by Pedro Sanchez on 4/24/19.
//  Copyright © 2019 SeniorDesign. All rights reserved.
//

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
     
     mergeSortedHearsayContentsArray(children: &a.comments)
     b2.sortComments()
     
     
     print("***")
     printHearsayRecursive(root: a, indent: 0)
     print("***")
     mergeSortedHearsayContentsArray(children: &b2.comments)
     
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
