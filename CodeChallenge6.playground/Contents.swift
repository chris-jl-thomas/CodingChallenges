import Foundation

// MARK: Version 1 - Function Takes an array of type T, and applys the function. Using _ in the defintion means we can take advantage of trailing closures so can be called like
// myfilter(array: [1,2,3]) { $0 % 2 == 0 } which would return an array of [2]

func myFilter<T>(array: [T], _ function:(T) -> Bool) -> [T] {
    var result = [T]()
    for value in array {
        if function(value) {
            result.append(value)
        }
    }
    return result
}

// MARK: Version 2 - Extension on Array. Again I take advantage of trailing closures
extension Array {
    func myFilter(_ function:(Element) -> Bool) -> [Element] {
        var result = [Element]()
        for value in self {
            if function(value) {
                result.append(value)
            }
        }
        return result
    }
}

