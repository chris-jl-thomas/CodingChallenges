import Foundation
import XCTest

func assertIsMaximum(testValue: String, _ array: [String]) -> Bool {
    for value in array {
        guard let doubleTestValue = Double(testValue) else { return false }
        guard let doubleValue = Double(value) else { return false }
        if doubleTestValue <= doubleValue {
            return false
        }
    }
    return true
}

class CodeChallenge2Tests: XCTestCase {
    
    // MARK: assertIsMaximum
    
    func test_assertIsMaximum_inputIsMaximum() {
        let testValue = "11.00"
        let array = ["10", "10.50", "0.3"]
        
        XCTAssertTrue(assertIsMaximum(testValue: testValue, array))
    }
    
    func test_assertIsMaximum_inputIsNotMaximum() {
        let testValue = "11.00"
        let array = ["11.00", "10.50", "100.3"]
        
        XCTAssertFalse(assertIsMaximum(testValue: testValue, array))
    }
    
    // MARK: fixPriceLabel
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
CodeChallenge2Tests.defaultTestSuite.run()


