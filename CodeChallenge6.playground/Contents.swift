import Foundation
import XCTest
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
extension Sequence {
    func myFilter(_ function:(Element) -> Bool) -> ContiguousArray<Element> {
        var result = ContiguousArray<Element>()
        for value in self {
            if function(value) {
                result.append(value)
            }
        }
        return result
    }
}

let string = "123456789123456789"
let filter = string.myFilter { $0 == "1" }
let offical = string.filter { $0 == "1" }
print(filter)
print(offical)
class CodeChallenge6Tests: XCTestCase {
    func test_filtersAnArrayOfIntsAndReturnsOnlyEvenNumbers() {
        let array = [1,2,3,4,5,6,7,8,9,10]
        XCTAssertEqual(array.myFilter { $0 % 2 == 0 } , [2,4,6,8,10]  )
    }
    
    func test_filtersAnArrayOfNamesAndReturnsOnlyNamesThatArentMike() {
        let array = ["Mike","Alex","Jim","Mike","Chris","John","Mike","Steve","Mike"]
        XCTAssertEqual(array.myFilter { $0 != "Mike" } , ["Alex", "Jim", "Chris", "John", "Steve"]  )
    }
    
    func test_filtersOutObjectsThatArentInts() {
        let array: [Any] = [1,2,"Terry",4,"5"]
        let expected: [Any] = [1,2,4]
        let actual = array.myFilter({ element -> Bool in
            if let _ = element as? Int {
                return true
            } else {
                return false
            }
        })
        
        XCTAssertEqual(actual.count, 3)
        XCTAssertEqual(actual[0] as? Int, expected[0] as? Int)
        XCTAssertEqual(actual[1] as? Int, expected[1] as? Int)
        XCTAssertEqual(actual[2] as? Int, expected[2] as? Int)
    }
}

class TestObserver: NSObject, XCTestObservation {
    func testCase(_ testCase: XCTestCase,
                  didFailWithDescription description: String,
                  inFile filePath: String?,
                  atLine lineNumber: Int) {
        assertionFailure(description, line: UInt(lineNumber))
    }
}

let testObserver = TestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)
CodeChallenge6Tests.defaultTestSuite.run()

