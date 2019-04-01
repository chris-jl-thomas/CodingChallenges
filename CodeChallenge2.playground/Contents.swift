import Foundation
import XCTest

class Challenge2 {
    static func fixPriceLabel(_ priceLabel: String) -> String {
        let numbers = filter(priceLabel
            .lowercased()
            .components(separatedBy: ",")
            .compactMap {
                return String($0.trimmingCharacters(in: .whitespaces)
                    .components(separatedBy: " ")[1].dropFirst())
            }
        )
        
        if numbers.count == 1 {
            return "Now £\(numbers.first!)"
        }
        
        let first = "Was £\(numbers.first!)"
        let last = "now £\(numbers.last!)"
        return ([first] + numbers.dropLast().dropFirst().map { "then £\($0)"} + [last])
            .joined(separator: ", ")
        
    }
    
    private static func filter(_ numbers:[String], result:[String]=[]) -> [String] {
        
        if let value = numbers.first {
            let remainingNumbers = Array(numbers.dropFirst())
            if assertMax(value, in: remainingNumbers) {
                return filter(remainingNumbers, result: result + [value])
            } else {
                return filter(remainingNumbers, result:result)
            }
        } else {
            return result
        }
    }
    
    private static func assertMax(_ testValue: String, in array: [String]) -> Bool {
        for value in array {
            guard let doubleTestValue = Double(testValue) else { return false }
            guard let doubleValue = Double(value) else { return false }
            if doubleTestValue <= doubleValue {
                return false
            }
        }
        return true
    }
}

Challenge2.fixPriceLabel("Was £10, then £11, then £8, now £6")

class CodeChallenge2Tests: XCTestCase {
    
    // MARK: fixPriceLabel
    
    func test_fixPriceLabel_inputDoesntChange_formatCorrect() {
        let input = "Was £10.00, then £9, then £8, now £6.50"
        XCTAssertEqual(Challenge2.fixPriceLabel(input), input)
    }
    
    func test_fixPriceLabel_nowOnly() {
        let input = "Was £10.00, then £9, then £8, now £16.50"
        XCTAssertEqual(Challenge2.fixPriceLabel(input), "Now £16.50")
    }
    
    func test_fixPriceLabel_wasnowOnly() {
        let input = "Was £17.00, then £9, then £8, now £16.50"
        XCTAssertEqual(Challenge2.fixPriceLabel(input), "Was £17.00, now £16.50")
    }
    
    func test_fixPriceLabel_wasthennowOnly() {
        let input = "Was £17.00, then £9, then £12.00, now £11.50"
        XCTAssertEqual(Challenge2.fixPriceLabel(input), "Was £17.00, then £12.00, now £11.50")
    }
    
    func test_fixPriceLabel_nowOnlyInput() {
        let input = "Now £11.50"
        XCTAssertEqual(Challenge2.fixPriceLabel(input), "Now £11.50")
    }
    
    func test_fixPriceLabel_InvalidString() {
        // SPEC says not to handle errors - so this proves it doesn't :)
        let input = "Now invalid string"
        XCTAssertEqual(Challenge2.fixPriceLabel(input), "Now £nvalid")
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
CodeChallenge2Tests.defaultTestSuite.run()

