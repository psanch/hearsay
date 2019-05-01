import UIKit

var a = [1,5,10]

func insertSorted(data: Int, arr: inout [Int]) {
    
    var i = 0
    
    while(i < arr.count && data > arr[i]){
        i+=1
    }
    
    if(i == arr.count){
        arr.append(data)
    }
    else{
        arr.insert(data, at: i)
    }
}

var x = 0
var y = 7
var z = 11

insertSorted(data: x, arr: &a)
print(a)
insertSorted(data: y, arr: &a)
print(a)
insertSorted(data: z, arr: &a)
print(a)

